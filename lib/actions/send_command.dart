import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/event.dart';

class SendCommand extends Action {
  final ClientRequestEvent command;

  SendCommand({required this.command});

  @override
  Map<String, dynamic> toJson() =>
      {"command": command.getName(), "body": command.toJson()};

  @override
  String toString() {
    return toJson().toString();
  }
}
