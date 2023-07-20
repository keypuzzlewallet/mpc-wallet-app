import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/screens/v1/views/coin_select_screen.dart';
import 'package:mobileapp/screens/v1/views/create_new_signing_screen.dart';
import 'package:mobileapp/screens/v1/views/qr_scan_screen.dart';
import 'package:mobileapp/screens/v1/views/wait_signing_screen.dart';
import 'package:mobileapp/services/kbus.dart';

class ScanSigningController extends FxController {
  String? transcationRequestJson = "";
  TextEditingController transactionRequestController = TextEditingController();

  ScanSigningController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  String getTag() {
    return "scan_signing_controller";
  }

  onTransactionRequestChangeChanged(String value) {
    transcationRequestJson = value;
  }

  sign() {
    if (transcationRequestJson == null ||
        transcationRequestJson!.trim() == "") {
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.ERROR,
              message: "Please enter transaction request"));
      return;
    }
    var signRequest =
        SigningRequest.fromJson(jsonDecode(transcationRequestJson!));
    getIt<KbusClient>().action(this, signRequest);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WaitSigningScreen(),
      ),
    );
  }

  scanQrCode() async {
    transcationRequestJson =
        await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QrScanScreen(),
      ),
    );
    transactionRequestController.text = transcationRequestJson ?? "";
  }

  goToNewRequest(bool isOnlyWhitelisted) async {
    BlockchainCoinItem? coinItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CoinSelectScreen(onlyEnabledCoin: true),
      ),
    );
    if (coinItem == null) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNewSigningScreen(
            blockchainCoinItem: coinItem, isOnlyWhitelisted: isOnlyWhitelisted),
      ),
    );
  }
}
