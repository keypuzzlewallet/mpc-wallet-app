import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';

part 'nonce_entity.g.dart';

@JsonSerializable()
@CopyWith()
class NonceEntity extends Equatable {
  final String pubkey;
  final KeyScheme keyScheme;
  final int nonceStart;
  final int nonceSize;
  final int currentNonce;
  final DateTime updatedAt;
  final DateTime createdAt;

  const NonceEntity({
    required this.pubkey,
    required this.keyScheme,
    required this.nonceStart,
    required this.nonceSize,
    required this.currentNonce,
    required this.updatedAt,
    required this.createdAt,
  });

  factory NonceEntity.fromJson(Map<String, dynamic> json) =>
      _$NonceEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NonceEntityToJson(this);

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
