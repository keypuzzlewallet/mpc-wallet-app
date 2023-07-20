import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/signing/signed_partial_signature_base64.dart';
import 'package:mobileapp/events/signing/signature_recid_hex.dart';
part 'signing_state_base64.g.dart';
@JsonSerializable()
@CopyWith()
class SigningStateBase64 extends Equatable implements Event, Action {
  final int t; // t
  final int n; // n
  final KeyScheme keyScheme; // keyScheme
  final List<SignedPartialSignatureBase64> signing_parts_base64; // signing_parts_base64
  final SignatureRecidHex? signature; // signature_hex

  SigningStateBase64 ({required this.t, required this.n, required this.keyScheme, required this.signing_parts_base64, this.signature});

  @override
  List<Object?> get props => [t, n, keyScheme, signing_parts_base64, signature];

  @override
  String toString() {
    return 'SigningStateBase64{t: $t, n: $n, keyScheme: $keyScheme, signing_parts_base64: $signing_parts_base64, signature: $signature}';
  }
  factory SigningStateBase64.fromJson(Map<String, dynamic> json) => _$SigningStateBase64FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SigningStateBase64ToJson(this);
  @override
  String getName() => name();
  static String name() => "SigningStateBase64";
}

