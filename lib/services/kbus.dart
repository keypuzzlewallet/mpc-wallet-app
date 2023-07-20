import 'dart:developer' as developer;

import 'package:event_bus/event_bus.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/services/sse_service.dart';

class KbusClient extends EventBus {
  Stream<T> onE<T>(clazz) {
    final stream = T == dynamic
        ? streamController.stream as Stream<T>
        : streamController.stream.where((event) => event is T).cast<T>();
    developer.log("${clazz.runtimeType.toString()} listens to ${T.toString()}");
    return stream.map((event) {
      developer.log(
          "${clazz.runtimeType.toString()} ~~~> ${event.runtimeType.toString()}:${event}");
      return event;
    });
  }

  // internal communicate between blocs and services
  void fireE(clazz, Action event) {
    developer.log(
        "${clazz.runtimeType.toString()} <~~~ ${event.runtimeType.toString()}:${event}");
    super.fire(event);
  }

  // direct user action when user do somethings from the UI
  // the different with fireE is that fireE will not trigger new request flow so it is easier to track the flow from log by requestId
  void action(clazz, Action event) {
    getIt<SseService>().newRequestFlow();
    fireE(clazz, event);
  }
}
