import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'encrypted_local_key.g.dart';
@JsonSerializable()
@CopyWith()
class EncryptedLocalKey extends Equatable implements Event, Action {
  final String pubkey; // pubkey
  final String encryptedKey; // encryptedKey
  final String encryptedNonce; // encryptedNonce
  final String algorithm; // signature algorithm

  EncryptedLocalKey ({required this.pubkey, required this.encryptedKey, required this.encryptedNonce, required this.algorithm});

  @override
  List<Object?> get props => [pubkey, encryptedKey, encryptedNonce, algorithm];

  @override
  String toString() {
    return 'EncryptedLocalKey{pubkey: $pubkey, encryptedKey: $encryptedKey, encryptedNonce: $encryptedNonce, algorithm: $algorithm}';
  }
  factory EncryptedLocalKey.fromJson(Map<String, dynamic> json) => _$EncryptedLocalKeyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EncryptedLocalKeyToJson(this);
  @override
  String getName() => name();
  static String name() => "EncryptedLocalKey";
}

