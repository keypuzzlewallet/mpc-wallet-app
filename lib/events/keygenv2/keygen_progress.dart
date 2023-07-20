import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
part 'keygen_progress.g.dart';
@JsonSerializable()
@CopyWith()
class KeygenProgress extends Equatable implements ClientRequestEvent, Action {
  final List<KeygenMember> members; // joined members
  final int progress; // approximate percentage of the key generation process. 0 to 100

  KeygenProgress ({required this.members, required this.progress});

  @override
  List<Object?> get props => [members, progress];

  @override
  String toString() {
    return 'KeygenProgress{members: $members, progress: $progress}';
  }
  factory KeygenProgress.fromJson(Map<String, dynamic> json) => _$KeygenProgressFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KeygenProgressToJson(this);
  @override
  String getName() => name();
  static String name() => "KeygenProgress";
}

