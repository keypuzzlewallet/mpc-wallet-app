import 'dart:convert';

import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/enums/fee_level.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/enums/request_transaction_type.dart';
import 'package:mobileapp/events/enums/signing_status.dart';
import 'package:mobileapp/events/signing/requests/eth_contract_request.dart';
import 'package:mobileapp/events/signing/requests/send_request.dart';
import 'package:mobileapp/events/signing/requests/send_token_request.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/signing/signing_result.dart';
import 'package:sqflite/sqflite.dart';

class SigningRequestDatabase {
  final Database db;
  final table = "signing_requests";

  SigningRequestDatabase(this.db);

  Future<void> save(String owner, SigningRequest entity) async {
    await db.insert(table, _toDbRow(owner, entity),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SigningRequest>> findAll(String owner) async {
    return (await db.query(table, orderBy: 'createdAt DESC', where: 'owner = ?', whereArgs: [owner])).map((row) => _fromDbRow(row)).toList();
  }

  Future<SigningRequest?> findById(String id) async {
    List<Map<String, dynamic>> wallets =
        await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (wallets.isEmpty) {
      return null;
    }
    return _fromDbRow(wallets[0]);
  }

  Map<String, dynamic> _toDbRow(String owner, SigningRequest wallet) {
    return {
      'id': wallet.id,
      'walletId': wallet.walletId,
      'blockchain': wallet.blockchain.name,
      'coin': wallet.coin.name,
      'owner': owner,
      'keyScheme': wallet.keyScheme.name,
      'pubkey': wallet.pubkey,
      'fromAddress': wallet.fromAddress,
      'threshold': wallet.threshold,
      'requestTransactionType': wallet.requestTransactionType.name,
      'status': wallet.status.name,
      'message': wallet.message,
      'signingResult': wallet.signingResult != null
          ? jsonEncode(wallet.signingResult)
          : null,
      'sendRequest':
          wallet.sendRequest != null ? jsonEncode(wallet.sendRequest) : null,
      'sendTokenRequest': wallet.sendTokenRequest != null
          ? jsonEncode(wallet.sendTokenRequest)
          : null,
      'ethSmartContractRequest': wallet.ethSmartContractRequest != null
          ? jsonEncode(wallet.ethSmartContractRequest)
          : null,
      'signers': jsonEncode(wallet.signers),
      'feeLevel': wallet.feeLevel.name,
      'fee': wallet.fee != null ? wallet.fee!.toString() : null,
      'version': wallet.version,
      'createdAt': DateTime.parse(wallet.createdAt).millisecondsSinceEpoch,
    };
  }

  SigningRequest _fromDbRow(Map<String, dynamic> row) {
    return SigningRequest(
        id: row['id'],
        walletId: row['walletId'],
        blockchain:
            Blockchain.values.firstWhere((e) => e.name == row['blockchain']),
        coin: Coin.values.firstWhere((e) => e.name == row['coin']),
        keyScheme:
            KeyScheme.values.firstWhere((e) => e.name == row['keyScheme']),
        pubkey: row['pubkey'],
        fromAddress: row['fromAddress'],
        threshold: row['threshold'],
        requestTransactionType: RequestTransactionType.values
            .firstWhere((e) => e.name == row['requestTransactionType']),
        status: SigningStatus.values.firstWhere((e) => e.name == row['status']),
        message: row['message'],
        signingResult: row['signingResult'] != null
            ? SigningResult.fromJson(jsonDecode(row['signingResult']))
            : null,
        sendRequest: row['sendRequest'] != null
            ? SendRequest.fromJson(jsonDecode(row['sendRequest']))
            : null,
        sendTokenRequest: row['sendTokenRequest'] != null
            ? SendTokenRequest.fromJson(jsonDecode(row['sendTokenRequest']))
            : null,
        ethSmartContractRequest: row['ethSmartContractRequest'] != null
            ? EthContractRequest.fromJson(
                jsonDecode(row['ethSmartContractRequest']))
            : null,
        signers: (jsonDecode(row['signers']) as List<dynamic>).map((e) => e as int).toList(),
        feeLevel: FeeLevel.values.firstWhere((e) => e.name == row['feeLevel']),
        fee: row['fee'] != null ? BigDecimal.parse(row['fee']) : null,
        version: row['version'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int).toIso8601String());
  }
}
