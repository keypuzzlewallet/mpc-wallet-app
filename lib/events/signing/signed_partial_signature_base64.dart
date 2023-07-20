import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'signed_partial_signature_base64.g.dart';
@JsonSerializable()
@CopyWith()
class SignedPartialSignatureBase64 extends Equatable implements Event, Action {
  final int party_id; // party_id
  final String part_base64; // part_base64
  final String signed_at; // signed_at

  SignedPartialSignatureBase64 ({required this.party_id, required this.part_base64, required this.signed_at});

  @override
  List<Object?> get props => [party_id, part_base64, signed_at];

  @override
  String toString() {
    return 'SignedPartialSignatureBase64{party_id: $party_id, part_base64: $part_base64, signed_at: $signed_at}';
  }
  factory SignedPartialSignatureBase64.fromJson(Map<String, dynamic> json) => _$SignedPartialSignatureBase64FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignedPartialSignatureBase64ToJson(this);
  @override
  String getName() => name();
  static String name() => "SignedPartialSignatureBase64";
}

