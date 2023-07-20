import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'protected_email_action_verify.g.dart';
@JsonSerializable()
@CopyWith()
class ProtectedEmailActionVerify extends Equatable implements Event, Action {
  final String actionId; // actionId
  final String token; // token

  ProtectedEmailActionVerify ({required this.actionId, required this.token});

  @override
  List<Object?> get props => [actionId, token];

  @override
  String toString() {
    return 'ProtectedEmailActionVerify{actionId: $actionId, token: $token}';
  }
  factory ProtectedEmailActionVerify.fromJson(Map<String, dynamic> json) => _$ProtectedEmailActionVerifyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProtectedEmailActionVerifyToJson(this);
  @override
  String getName() => name();
  static String name() => "ProtectedEmailActionVerify";
}

