import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'keygen_member.g.dart';
@JsonSerializable()
@CopyWith()
class KeygenMember extends Equatable implements Event, Action {
  final int party_id; // party_id
  final String party_name; // name of party member. This is to help easier to identify and assign signer when signing a transaction

  KeygenMember ({required this.party_id, required this.party_name});

  @override
  List<Object?> get props => [party_id, party_name];

  @override
  String toString() {
    return 'KeygenMember{party_id: $party_id, party_name: $party_name}';
  }
  factory KeygenMember.fromJson(Map<String, dynamic> json) => _$KeygenMemberFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KeygenMemberToJson(this);
  @override
  String getName() => name();
  static String name() => "KeygenMember";
}

