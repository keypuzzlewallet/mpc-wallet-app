import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'issue_index_msg.g.dart';
@JsonSerializable()
@CopyWith()
class IssueIndexMsg extends Equatable implements Event, Action {
  final List<int> parties; // parties
  final int? party_id; // party_id
  final String? party_name; // party_name

  IssueIndexMsg ({required this.parties, this.party_id, this.party_name});

  @override
  List<Object?> get props => [parties, party_id, party_name];

  @override
  String toString() {
    return 'IssueIndexMsg{parties: $parties, party_id: $party_id, party_name: $party_name}';
  }
  factory IssueIndexMsg.fromJson(Map<String, dynamic> json) => _$IssueIndexMsgFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IssueIndexMsgToJson(this);
  @override
  String getName() => name();
  static String name() => "IssueIndexMsg";
}

