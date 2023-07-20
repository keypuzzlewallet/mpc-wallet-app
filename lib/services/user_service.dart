import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/keygenv2/keygen_member.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/app_config.dart';
import 'package:mobileapp/models/app_env.dart';
import 'package:mobileapp/models/backup_wallet.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_database.dart';

class UserService {
  final FlutterSecureStorage _secureStorage;
  final _aOptions = const AndroidOptions(encryptedSharedPreferences: true);
  final _iOptions =
  const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  UserService(this._secureStorage);

  Future<String> readLoginEmail() async {
    return (await _secureStorage.read(
        key: "loginEmail",
        iOptions: _iOptions,
        aOptions: _aOptions))!;
  }

  Future<void> storeLoginEmail(String email) async {
    await _secureStorage.write(
        key: "loginEmail",
        value: email,
        iOptions: _iOptions,
        aOptions: _aOptions);
  }

  Future<String?> getUserToken() async {
    User? loginUser = FirebaseAuth.instance.currentUser;
    if (loginUser == null) {
      return null;
    }
    return await loginUser.getIdToken();
  }
}
