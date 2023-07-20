import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/keygenv2/encrypted_local_key.dart';
part 'protected_update_hot_wallet_nonce.g.dart';
@JsonSerializable()
@CopyWith()
class ProtectedUpdateHotWalletNonce extends Equatable implements Event, Action {
  final String pubkey; // pubkey that client request generate nonces
  final KeyScheme keyScheme; // keyScheme
  final int nonceStartIndex; // nonceStartIndex
  final int nonceSize; // nonceSize
  final EncryptedLocalKey encryptedLocalKey; // encryptedLocalKey

  ProtectedUpdateHotWalletNonce ({required this.pubkey, required this.keyScheme, required this.nonceStartIndex, required this.nonceSize, required this.encryptedLocalKey});

  @override
  List<Object?> get props => [pubkey, keyScheme, nonceStartIndex, nonceSize, encryptedLocalKey];

  @override
  String toString() {
    return 'ProtectedUpdateHotWalletNonce{pubkey: $pubkey, keyScheme: $keyScheme, nonceStartIndex: $nonceStartIndex, nonceSize: $nonceSize, encryptedLocalKey: $encryptedLocalKey}';
  }
  factory ProtectedUpdateHotWalletNonce.fromJson(Map<String, dynamic> json) => _$ProtectedUpdateHotWalletNonceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProtectedUpdateHotWalletNonceToJson(this);
  @override
  String getName() => name();
  static String name() => "ProtectedUpdateHotWalletNonce";
}

