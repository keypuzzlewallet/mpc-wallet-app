import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/signing/signing_state_base64.dart';
import 'package:mobileapp/events/keygenv2/encrypted_local_key.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
part 'native_signing_request.g.dart';
@JsonSerializable()
@CopyWith()
class NativeSigningRequest extends Equatable implements Event, Action {
  final SigningStateBase64 stateBase64; // signing state
  final String hexData; // data to sign in hex format. no 0x prefix. lower case.
  final EncryptedLocalKey encryptedLocalKey; // encryptedLocalKey
  final KeyScheme keyScheme; // key scheme used to sign this message
  final int partyId; // party id who is signing
  final List<int> signers; // signers who are assigned to sign this message
  final String password; // password to decrypt the generated private key
  final int nonce; // nonce index to sign. This only use for EDDSA at the moment

  NativeSigningRequest ({required this.stateBase64, required this.hexData, required this.encryptedLocalKey, required this.keyScheme, required this.partyId, required this.signers, required this.password, required this.nonce});

  @override
  List<Object?> get props => [stateBase64, hexData, encryptedLocalKey, keyScheme, partyId, signers, password, nonce];

  @override
  String toString() {
    return 'NativeSigningRequest{stateBase64: $stateBase64, hexData: $hexData, encryptedLocalKey: $encryptedLocalKey, keyScheme: $keyScheme, partyId: $partyId, signers: $signers, password: $password, nonce: $nonce}';
  }
  factory NativeSigningRequest.fromJson(Map<String, dynamic> json) => _$NativeSigningRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NativeSigningRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "NativeSigningRequest";
}

