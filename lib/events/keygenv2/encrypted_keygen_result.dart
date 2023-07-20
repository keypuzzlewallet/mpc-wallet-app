import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_with_scheme.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
part 'encrypted_keygen_result.g.dart';
@JsonSerializable()
@CopyWith()
class EncryptedKeygenResult extends Equatable implements Event, Action {
  final int party_id; // party_id
  final List<EncryptedKeygenWithScheme> encryptedKeygenWithScheme; // encryptedKeygenWithScheme
  final List<KeygenMember> members; // members

  EncryptedKeygenResult ({required this.party_id, required this.encryptedKeygenWithScheme, required this.members});

  @override
  List<Object?> get props => [party_id, encryptedKeygenWithScheme, members];

  @override
  String toString() {
    return 'EncryptedKeygenResult{party_id: $party_id, encryptedKeygenWithScheme: $encryptedKeygenWithScheme, members: $members}';
  }
  factory EncryptedKeygenResult.fromJson(Map<String, dynamic> json) => _$EncryptedKeygenResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EncryptedKeygenResultToJson(this);
  @override
  String getName() => name();
  static String name() => "EncryptedKeygenResult";
}

