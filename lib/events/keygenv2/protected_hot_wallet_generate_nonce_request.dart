import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/keygenv2/encrypted_local_key.dart';
part 'protected_hot_wallet_generate_nonce_request.g.dart';
@JsonSerializable()
@CopyWith()
class ProtectedHotWalletGenerateNonceRequest extends Equatable implements ClientRequestEvent, Action {
  final String pubkey; // pubkey that client request generate nonces
  final KeyScheme keyScheme; // keyScheme
  final int nonceStartIndex; // nonceStartIndex
  final int nonceSize; // nonceSize
  final String roomId; // roomId
  final EncryptedLocalKey encryptedLocalKey; // encryptedLocalKey

  ProtectedHotWalletGenerateNonceRequest ({required this.pubkey, required this.keyScheme, required this.nonceStartIndex, required this.nonceSize, required this.roomId, required this.encryptedLocalKey});

  @override
  List<Object?> get props => [pubkey, keyScheme, nonceStartIndex, nonceSize, roomId, encryptedLocalKey];

  @override
  String toString() {
    return 'ProtectedHotWalletGenerateNonceRequest{pubkey: $pubkey, keyScheme: $keyScheme, nonceStartIndex: $nonceStartIndex, nonceSize: $nonceSize, roomId: $roomId, encryptedLocalKey: $encryptedLocalKey}';
  }
  factory ProtectedHotWalletGenerateNonceRequest.fromJson(Map<String, dynamic> json) => _$ProtectedHotWalletGenerateNonceRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProtectedHotWalletGenerateNonceRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "ProtectedHotWalletGenerateNonceRequest";
}

