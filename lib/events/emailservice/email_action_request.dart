import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'email_action_request.g.dart';
@JsonSerializable()
@CopyWith()
class EmailActionRequest extends Equatable implements ClientRequestEvent, Action {
  final String command; // command to send. We must verify if command is allowed to send by client email action. For example, HotSigningRequest command to request server hot signing
  final String commandBody; // command body to send

  EmailActionRequest ({required this.command, required this.commandBody});

  @override
  List<Object?> get props => [command, commandBody];

  @override
  String toString() {
    return 'EmailActionRequest{command: $command, commandBody: $commandBody}';
  }
  factory EmailActionRequest.fromJson(Map<String, dynamic> json) => _$EmailActionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmailActionRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "EmailActionRequest";
}

