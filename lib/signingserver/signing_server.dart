import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mobileapp/events/keygenv2/issue_index_msg.dart';
import 'package:mobileapp/events/keygenv2/issued_unique_idx.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

class SigningServer {
  HttpServer? server;
  Map<String, Room> rooms = Map();

  stop() async {
    if (server != null) {
      print("stopping server...");
      await server!.close(force: true);
    }
  }

  Future<String> getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      NetworkInterface vpnInterface =
          interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface =
            interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) =>
              !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return "unknown";
        }
      }
    }
  }

  Future<String> start(int port) async {
    var router = Router();
    router.get('/rooms/<roomId>/subscribe',
        (Request request, String roomId) async {
      var room = rooms.putIfAbsent(roomId, () => Room());
      print('a client connected to room $roomId');
      final streamController = room.newStream();
      for (var msg in room._messages) {
        print('send backlog msg $roomId to client');
        await broadcastToStream(streamController, "new-message", msg);
      }
      Timer.periodic(const Duration(seconds: 1), (t) {
        streamController.add(':\n'.codeUnits);
      });
      streamController.add(':\n'.codeUnits);

      return Response.ok(streamController.stream, headers: {
        'Content-Type': 'text/event-stream',
        'cache-control': 'no-cache',
        'expires': '0',
      }, context: {
        "shelf.io.buffer_output": false
      });
    });
    router.get('/ping', (Request request) {
      return Future.value(Response.ok("pong"));
    });
    router.post('/rooms/<roomId>/issue_unique_idx',
        (Request request, String roomId) async {
      var room = rooms.putIfAbsent(roomId, () => Room());
      var msg = await request.readAsString();
      var issueIndexMsg = IssueIndexMsg.fromJson(jsonDecode(msg));
      room.parties = issueIndexMsg.parties;
      if (issueIndexMsg.party_id == null) {
        return Response.ok(jsonEncode(
            IssuedUniqueIdx(unique_idx: room.getIdx(issueIndexMsg.party_name))
                .toJson()));
      } else {
        while (true) {
          // parties have to join in order
          var lastJoinIndex = room.lastJoinedPartyId == null
              ? -1
              : room.parties.indexOf(room.lastJoinedPartyId!);
          var partyIndex = room.parties.indexOf(issueIndexMsg.party_id!);
          if (lastJoinIndex + 1 == partyIndex) {
            room.lastJoinedPartyId = issueIndexMsg.party_id;
            return Response.ok(jsonEncode(IssuedUniqueIdx(
                    unique_idx: room.getIdx(issueIndexMsg.party_name))
                .toJson()));
          }
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }
    });
    router.post('/rooms/<roomId>/broadcast',
        (Request request, String roomId) async {
      var room = rooms.putIfAbsent(roomId, () => Room());
      var msg = await request.readAsString();
      room.storeMessage(msg);
      await broadcast(room, "new-message", msg);
      return Response.ok(null);
    });

    router.get('/rooms/<roomId>/members',
        (Request request, String roomId) async {
      var room = rooms.putIfAbsent(roomId, () => Room());
      return Response.ok(jsonEncode(room.namedParties));
    });

    var handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(router);
    server = await io.serve(handler, InternetAddress.anyIPv4, port);
    var ipAddress = await getLocalIpAddress();
    print("started signing server at $ipAddress:$port");
    return ipAddress;
  }

  Future<void> broadcast(Room room, String event, String message) async {
    for (var stream in room._streams) {
      await broadcastToStream(stream, event, message);
    }
  }

  Future<void> broadcastToStream(
      StreamController<List<int>> stream, String event, String message) async {
    stream.add('event: $event\ndata: $message\n\n'.codeUnits);
  }
}

class Room {
  List<StreamController<List<int>>> _streams = [];
  List<String> _messages = [];
  List<int> parties = [];
  List<KeygenMember> namedParties = [];
  int? lastJoinedPartyId;
  var _idx = 1;

  StreamController<List<int>> newStream() {
    final stream = StreamController<List<int>>();
    _streams.add(stream);
    return stream;
  }

  storeMessage(String msg) {
    _messages.add(msg);
  }

  readMessages() {
    return _messages;
  }

  getIdx(String? partyName) {
    if (partyName == null) {
      return _idx++;
    } else {
      final newPartyId = _idx++;
      namedParties
          .add(KeygenMember(party_id: newPartyId, party_name: partyName));
      return newPartyId;
    }
  }
}
