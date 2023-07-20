import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'signing_session_failed.g.dart';
@JsonSerializable()
@CopyWith()
class SigningSessionFailed extends Equatable implements Event, Action {
  final String signingId; // signingId
  final String error; // error

  SigningSessionFailed ({required this.signingId, required this.error});

  @override
  List<Object?> get props => [signingId, error];

  @override
  String toString() {
    return 'SigningSessionFailed{signingId: $signingId, error: $error}';
  }
  factory SigningSessionFailed.fromJson(Map<String, dynamic> json) => _$SigningSessionFailedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SigningSessionFailedToJson(this);
  @override
  String getName() => name();
  static String name() => "SigningSessionFailed";
}

