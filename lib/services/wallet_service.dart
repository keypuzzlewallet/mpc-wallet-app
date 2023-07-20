import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_with_scheme.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';
import 'package:mobileapp/models/backup_wallet.dart';
import 'package:mobileapp/models/nonce_entity.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/nonce_database.dart';
import 'package:mobileapp/services/wallet_database.dart';

class WalletService {
  static String offlineUserId = "offline-wallet-user";
  final WalletDatabase _walletDatabase;
  final NonceDatabase _nonceDatabase;
  final FlutterSecureStorage _secureStorage;
  final String _secretChars =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*()_+{}:<>?|[];,./~";
  final _aOptions = const AndroidOptions(encryptedSharedPreferences: true);
  final _iOptions =
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  WalletService(this._secureStorage, this._walletDatabase, this._nonceDatabase);

  Future<void> storeWallet(
      String keygenId,
      List<WalletCreationConfigPubkey> pubkeys,
      int t,
      int n,
      EncryptedKeygenResult encryptedKeygenResult,
      String walletName,
      String signerName,
      int partyId,
      List<KeygenMember> members,
      String? owner,
      WalletCreationConfig walletCreationConfig,
      bool isHotSigningWallet) async {
    await storeNonce(encryptedKeygenResult);
    await _insertWallet(WalletEntity(
        walletId: keygenId,
        pubkeys: pubkeys,
        name: walletName,
        signerName: signerName,
        noMembers: n,
        threshold: t,
        partyId: partyId,
        createdAt: DateTime.now(),
        encryptedKeygenResult: encryptedKeygenResult,
        members: members,
        owner: owner ?? WalletService.offlineUserId,
        walletCreationConfig: walletCreationConfig,
        isHotSigningWallet: isHotSigningWallet,
        // default coins are BTC and ETH
        enabledBlockchains: [
          EnabledBlockchain(blockchain: Blockchain.BITCOIN, coins: [Coin.BTC]),
          EnabledBlockchain(blockchain: Blockchain.ETHEREUM, coins: [Coin.ETH])
        ]));
  }

  Future<void> storeNonce(EncryptedKeygenResult encryptedKeygenResult) async {
    for (var key in encryptedKeygenResult.encryptedKeygenWithScheme) {
      await _nonceDatabase.updateNonce(
          key.encryptedLocalKey.pubkey,
          key.keyScheme,
          key.nonceStartIndex,
          key.nonceSize,
          key.nonceStartIndex + 1);
    }
  }

  Future<int> updateWalletNonceIndex(
      String pubkey, KeyScheme keyScheme, int currentNonce) async {
    return _nonceDatabase.updateNonceIndex(pubkey, keyScheme, currentNonce);
  }

  Future<void> updateWalletNonce(
    WalletEntity oldWallet,
    EncryptedKeygenWithScheme updatedPrivateKey,
  ) async {
    // backup old wallet
    await _backupWallet(oldWallet.walletId);
    await _nonceDatabase.updateNonce(
        updatedPrivateKey.encryptedLocalKey.pubkey,
        updatedPrivateKey.keyScheme,
        updatedPrivateKey.nonceStartIndex,
        updatedPrivateKey.nonceSize,
        updatedPrivateKey.nonceStartIndex);
    EncryptedKeygenResult encryptedKeygenResult =
        oldWallet.encryptedKeygenResult.copyWith(
            encryptedKeygenWithScheme: oldWallet
                .encryptedKeygenResult.encryptedKeygenWithScheme
                .where((element) =>
                    element.keyScheme != updatedPrivateKey.keyScheme)
                .toList());
    encryptedKeygenResult.encryptedKeygenWithScheme.add(updatedPrivateKey);
    return _insertWallet(
        oldWallet.copyWith(encryptedKeygenResult: encryptedKeygenResult));
  }

  Future<void> updateWalletEnabledBlockchains(
      String walletId, List<EnabledBlockchain> enabledBlockchains) async {
    return _walletDatabase.updateWalletEnabledBlockchains(
        walletId, enabledBlockchains);
  }

  Future<void> storeWalletFromBackup(
      WalletEntity wallet, String encryptionKeyValue) async {
    await storeNonce(wallet.encryptedKeygenResult);
    await _insertWallet(wallet.copyWith(
        owner: FirebaseAuth.instance.currentUser?.uid ??
            WalletService.offlineUserId));
    await _storeEncryptionKey(
        _getEncryptionKeyValue(wallet.walletId), encryptionKeyValue);
  }

  // migrate if necessary
  Future<List<WalletEntity>> getWallets(String? owner) {
    return _walletDatabase.getWallets(owner ?? WalletService.offlineUserId);
  }

  // migrate if necessary
  BackupWallet recoverWalletFromBackup(String backupJson) {
    Map<String, dynamic> jsonMap = json.decode(backupJson);
    return BackupWallet.fromJson(jsonMap);
  }

  Future<String> createEncryptionKey(String walletId) async {
    final String encryptionKey = _getEncryptionKeyValue(walletId);
    String securedRandomPassword = "";
    for (int i = 0; i < 64; i++) {
      securedRandomPassword +=
          _secretChars[Random.secure().nextInt(_secretChars.length)];
    }
    await _storeEncryptionKey(encryptionKey, securedRandomPassword);
    return securedRandomPassword;
  }

  Future<String> getEncryptionKey(String walletId) async {
    return (await _secureStorage.read(
        key: _getEncryptionKeyValue(walletId),
        iOptions: _iOptions,
        aOptions: _aOptions))!;
  }

  // we need to have one key per wallet, so it make restore and backup safer and easier as we don't need to extra wallet but only encrypt the encryption key of the wallet
  String _getEncryptionKeyValue(String walletId) => "EncryptionKey-$walletId";

  Future<void> _storeEncryptionKey(
      String encryptionKey, String securedRandomPassword) async {
    // double check again to make sure we do not override the existing key that may cause data loss
    if (await _secureStorage.containsKey(key: encryptionKey)) {
      throw Exception("encryption key already exists");
    }
    await _secureStorage.write(
        key: encryptionKey,
        value: securedRandomPassword,
        iOptions: _iOptions,
        aOptions: _aOptions);
  }

  Future<WalletEntity?> getWalletById(String walletId) {
    return _walletDatabase.getWallet(walletId);
  }

  Future<WalletEntity?> getWalletByPubkey(String? owner, String pubkey) async {
    List<WalletEntity> entities =
        await _walletDatabase.getWallets(owner ?? WalletService.offlineUserId);
    int index = entities.indexWhere((element) =>
        element.pubkeys.indexWhere((element) => element.pubkey == pubkey) !=
        -1);
    if (index == -1) {
      return null;
    } else {
      return entities[index];
    }
  }

  Future<NonceEntity?> getNonce(String pubkey, KeyScheme keyScheme) async {
    return _nonceDatabase.getNonce(pubkey, keyScheme);
  }

  Future<void> _insertWallet(WalletEntity walletEntity) async {
    await _walletDatabase.insert(walletEntity);
  }

  Future<void> _backupWallet(String walletId) async {
    await _walletDatabase.backupWallet(walletId);
  }
}
