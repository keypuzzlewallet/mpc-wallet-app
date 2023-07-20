import 'dart:convert';

import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:sqflite/sqflite.dart';

class WalletDatabase {
  final Database db;
  final table = "wallets";

  WalletDatabase(this.db);

  Future<void> insert(WalletEntity wallet) async {
    await db.insert(table, _toDbRow(wallet),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<void> backupWallet(String walletId) async {
    await db.update(
        table,
        {
          'walletId':
              "$walletId-backup-${DateTime.now().millisecondsSinceEpoch}",
          'owner': ''
        },
        where: 'walletId = ?',
        whereArgs: [walletId]);
  }

  Future<List<WalletEntity>> getWallets(String owner) async {
    return (await db.query(table, where: 'owner = ?', whereArgs: [owner]))
        .map((row) => _fromDbRow(row))
        .toList();
  }

  Future<WalletEntity?> getWallet(String walletId) async {
    List<Map<String, dynamic>> wallets =
        await db.query(table, where: 'walletId = ?', whereArgs: [walletId]);
    if (wallets.isEmpty) {
      return null;
    }
    return _fromDbRow(wallets[0]);
  }

  Map<String, dynamic> _toDbRow(WalletEntity wallet) {
    return {
      'walletId': wallet.walletId,
      'pubkeys': jsonEncode(wallet.pubkeys),
      'name': wallet.name,
      'signerName': wallet.signerName,
      'noMembers': wallet.noMembers,
      'threshold': wallet.threshold,
      'partyId': wallet.partyId,
      'createdAt': wallet.createdAt.millisecondsSinceEpoch,
      'encryptedKeygenResult': jsonEncode(wallet.encryptedKeygenResult),
      'members': jsonEncode(wallet.members),
      'owner': wallet.owner,
      'walletCreationConfig': jsonEncode(wallet.walletCreationConfig),
      'isHotSigningWallet': wallet.isHotSigningWallet ? 1 : 0,
      'enabledBlockchains': jsonEncode(wallet.enabledBlockchains),
    };
  }

  WalletEntity _fromDbRow(Map<String, dynamic> row) {
    return WalletEntity(
      walletId: row['walletId'],
      pubkeys: (jsonDecode(row['pubkeys']) as List<dynamic>)
          .map((e) => WalletCreationConfigPubkey.fromJson(e))
          .toList(),
      name: row['name'],
      signerName: row['signerName'],
      noMembers: row['noMembers'],
      threshold: row['threshold'],
      partyId: row['partyId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt']),
      encryptedKeygenResult: EncryptedKeygenResult.fromJson(
          jsonDecode(row['encryptedKeygenResult'])),
      members: (jsonDecode(row['members']) as List<dynamic>)
          .map((e) => KeygenMember.fromJson(e))
          .toList(),
      owner: row['owner'],
      walletCreationConfig: WalletCreationConfig.fromJson(
          jsonDecode(row['walletCreationConfig'])),
      isHotSigningWallet: row['isHotSigningWallet'] == 1,
      enabledBlockchains:
          (jsonDecode(row['enabledBlockchains']) as List<dynamic>)
              .map((e) => EnabledBlockchain.fromJson(e))
              .toList(),
    );
  }

  Future<void> updateWalletEnabledBlockchains(
      String walletId, List<EnabledBlockchain> enabledBlockchains) {
    return db.update(
        table,
        {
          'enabledBlockchains': jsonEncode(enabledBlockchains),
        },
        where: 'walletId = ?',
        whereArgs: [walletId]);
  }
}
