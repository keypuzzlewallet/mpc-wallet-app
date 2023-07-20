import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';

part 'wallet_entity.g.dart';

@JsonSerializable()
@CopyWith()
class WalletEntity extends Equatable {
  final String walletId;
  final List<WalletCreationConfigPubkey> pubkeys;
  final String name;
  final String signerName;
  final int noMembers;
  final int threshold;
  final int partyId;
  final DateTime createdAt;
  final EncryptedKeygenResult encryptedKeygenResult;
  final List<KeygenMember> members;
  final String owner;
  final WalletCreationConfig walletCreationConfig;
  final bool isHotSigningWallet;
  final List<EnabledBlockchain> enabledBlockchains;

  const WalletEntity({
    required this.walletId,
    required this.pubkeys,
    required this.name,
    required this.signerName,
    required this.noMembers,
    required this.threshold,
    required this.partyId,
    required this.createdAt,
    required this.encryptedKeygenResult,
    required this.members,
    required this.owner,
    required this.walletCreationConfig,
    required this.isHotSigningWallet,
    required this.enabledBlockchains,
  });

  factory WalletEntity.fromJson(Map<String, dynamic> json) =>
      _$WalletEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WalletEntityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  List<Object> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object)
      .toList();
}
