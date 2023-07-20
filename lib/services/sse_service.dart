import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/actions/update_connection_status.dart';
import 'package:mobileapp/dispatch.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/publicapi/user_ping.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/user_service.dart';
import 'package:mobileapp/services/utils.dart';

// Use this class to send back message to server by .command(...)
class SseService {
  final String userStreamId = generateId("SSE", len: 24);

  //final bool loggingKeepAlive = false;
  bool isHotWallet = false;
  final String host;
  final EventBus eventBus;
  final int maxReconnectDelay = 30;
  bool isConnected = false;
  bool isConnecting = false;
  String requestId = generateId("RID", len: 24);
  Timer? healthCheckTimer;
  Timer? reconnectTimer;
  StreamSubscription<SSEModel>? stream;
  DateTime lastReceived = DateTime.now();

  SseService(this.host, this.eventBus);

  newRequestFlow() {
    requestId = generateId("RID", len: 24);
  }

  Future<void> establishConnectionAndWait() async {
    // to prevent create duplicate sse subscription
    if (isConnecting) {
      return;
    }
    var channelUrl = '$host/stream/user/$userStreamId';

    _establishConnection(channelUrl, 0.5);

    while (!isConnected) {
      developer.log("wait for connection...");
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    isConnecting = false;

    getIt<KbusClient>().fireE(this, UpdateConnectionStatus(false));
    healthCheckTimer ??=
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        await _request("/health-check", "GET", {}, requestId, false, true);
        getIt<KbusClient>().fireE(this, UpdateConnectionStatus(true));
      } catch (e, stacktrace) {
        print(stacktrace);
        developer.log("health check failed: $e");
        getIt<KbusClient>().fireE(this, UpdateConnectionStatus(false));
      }
    });
    reconnectTimer ??=
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (isHotWallet && !isConnected) {
        _establishConnection(channelUrl, 0.5);
      } else if (isConnected &&
          DateTime.now().millisecondsSinceEpoch -
                  lastReceived.millisecondsSinceEpoch >
              10 * 1000) {
        // server send ping every 5 seconds
        // if no message received for 10 seconds
        // server may lost connection to client, so reconnect
        _establishConnection(channelUrl, 0.5);
      }
    });
    // Timer.periodic(const Duration(seconds: 5), (timer) {
    //   _request("/stream/keep-alive/$userStreamId", "POST", {}, requestId,
    //       loggingKeepAlive);
    // });
  }

  Future<void> closeConnection() async {
    developer.log("terminating streams...");
    if (healthCheckTimer != null) {
      healthCheckTimer!.cancel();
      healthCheckTimer = null;
    }
    if (reconnectTimer != null) {
      reconnectTimer!.cancel();
      reconnectTimer = null;
    }
    if (stream != null) {
      await stream!.cancel();
      stream = null;
    }
    isConnected = false;
  }

  void _establishConnection(String channelUrl, double delay) {
    isConnecting = true;
    print("connecting to $channelUrl");
    stream ??= SSEClient.subscribeToSSE(url: channelUrl, header: {
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
    }).listen((event) {
      lastReceived = DateTime.now();
      if (!isConnected) {
        developer.log("stream connected");
        isConnected = true;
        getIt<KbusClient>().fireE(this, UpdateConnectionStatus(isConnected));
      }
      if ((event.event != UserPing.name())) {
        // || loggingKeepAlive) {
        developer.log("$requestId ${event.event} ~~~> ${event.data}");
      }
      if (event.event != null && event.event! != "") {
        dispatchToStore(eventBus, event.event!, event.data ?? "{}");
      }
    })
      ..onError((err) {
        isConnected = false;
        stream = null;
        getIt<KbusClient>().fireE(this, UpdateConnectionStatus(isConnected));
        _onError(err.toString(), null);
        Future.delayed(
            Duration(
                seconds: delay > maxReconnectDelay
                    ? maxReconnectDelay
                    : delay.round()),
            () => _establishConnection(channelUrl, delay * 1.5));
      });
  }

  Future<void> _commandTopic(String topic, Event body) => _request(
      "/command/$topic", "POST", body.toJson(), requestId, true, false);

  Future<void> command(Event body) => _commandTopic(body.getName(), body);

  Future<void> _request(String path, String method, Map<String, dynamic> body,
      String requestId, bool logging, bool throwable) async {
    if (isHotWallet) {
      try {
        if (!isConnected) {
          throw Exception("Connection lost");
        }
        var url = host.toLowerCase().startsWith("https")
            ? Uri.https(host.toLowerCase().replaceFirst("https://", ""), path)
            : Uri.http(host.toLowerCase().replaceFirst("http://", ""), path);
        String? token = await getIt<UserService>().getUserToken();
        var headers = token != null
            ? {
                "X-Request-ID": requestId,
                "X-Token": token,
                "X-Stream-ID": userStreamId,
                "Content-Type": "application/json"
              }
            : {
                "X-Request-ID": requestId,
                "X-Stream-ID": userStreamId,
                "Content-Type": "application/json"
              };
        if (method == "POST") {
          String jsonStr = json.encode(body);
          if (logging) {
            developer.log("$requestId $method $path <~~~ $jsonStr");
          }
          await http
              .post(url, headers: headers, body: jsonStr)
              .then((response) => _logResponse(path, method, response, logging))
              .onError((error, stackTrace) =>
                  _onError(error.toString(), stackTrace));
        } else if (method == "GET") {
          if (logging) {
            developer.log("$requestId $method $path <~~~");
          }
          await http
              .get(url, headers: headers)
              .then((response) => _logResponse(path, method, response, logging))
              .onError((error, stackTrace) =>
                  _onError(error.toString(), stackTrace));
        }
      } on FirebaseException catch (err, stacktrace) {
        print(stacktrace);
        if (throwable) {
          rethrow;
        } else {
          _onError(err.toString(), null, code: 401);
        }
      } catch (err) {
        if (throwable) {
          rethrow;
        } else {
          _onError(err.toString(), null);
        }
      }
    }
  }

  _logResponse(String path, String method, Response response, bool logging) {
    if (logging) {
      developer.log(
          '$requestId $method $path ~~~> ${response.statusCode} ${response.body}');
    }
  }

  void _onError(String err, StackTrace? stackTrace, {int? code}) {
    developer.log(err, stackTrace: stackTrace);
    eventBus.fire(Alert(level: AlertLevel.ERROR, message: err, code: code));
  }
}
