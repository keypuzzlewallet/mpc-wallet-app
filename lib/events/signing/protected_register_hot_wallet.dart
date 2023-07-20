import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
part 'protected_register_hot_wallet.g.dart';
@JsonSerializable()
@CopyWith()
class ProtectedRegisterHotWallet extends Equatable implements Event, Action {
  final String keygenId; // keygenId
  final int numberOfMembers; // numberOfMembers
  final int threshold; // threshold
  final String walletName; // walletName
  final int? partyId; // partyId
  final List<KeygenMember> members; // members
  final EncryptedKeygenResult encryptedKeygenResult; // encrypted local key
  final WalletCreationConfig walletCreationConfig; // walletCreationConfig
  final List<String> authorizedUsers; // userId which can request this hot wallet to sign a transaction

  ProtectedRegisterHotWallet ({required this.keygenId, required this.numberOfMembers, required this.threshold, required this.walletName, this.partyId, required this.members, required this.encryptedKeygenResult, required this.walletCreationConfig, required this.authorizedUsers});

  @override
  List<Object?> get props => [keygenId, numberOfMembers, threshold, walletName, partyId, members, encryptedKeygenResult, walletCreationConfig, authorizedUsers];

  @override
  String toString() {
    return 'ProtectedRegisterHotWallet{keygenId: $keygenId, numberOfMembers: $numberOfMembers, threshold: $threshold, walletName: $walletName, partyId: $partyId, members: $members, encryptedKeygenResult: $encryptedKeygenResult, walletCreationConfig: $walletCreationConfig, authorizedUsers: $authorizedUsers}';
  }
  factory ProtectedRegisterHotWallet.fromJson(Map<String, dynamic> json) => _$ProtectedRegisterHotWalletFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProtectedRegisterHotWalletToJson(this);
  @override
  String getName() => name();
  static String name() => "ProtectedRegisterHotWallet";
}

