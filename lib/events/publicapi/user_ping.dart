import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'user_ping.g.dart';
@JsonSerializable()
@CopyWith()
class UserPing extends Equatable implements Event, Action {
  final String userStreamId; // userStreamId
  final DateTime pingAt; // message

  UserPing ({required this.userStreamId, required this.pingAt});

  @override
  List<Object?> get props => [userStreamId, pingAt];

  @override
  String toString() {
    return 'UserPing{userStreamId: $userStreamId, pingAt: $pingAt}';
  }
  factory UserPing.fromJson(Map<String, dynamic> json) => _$UserPingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserPingToJson(this);
  @override
  String getName() => name();
  static String name() => "UserPing";
}

