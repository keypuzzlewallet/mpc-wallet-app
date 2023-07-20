import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/select_default_wallet.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_service.dart';

class WalletSelectController extends FxController {
  WalletSelectController();

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
    return "wallet_select_controller";
  }

  onSelectWallet(WalletEntity wallet) {
    Navigator.of(context).pop(wallet);
  }

  Future<List<WalletEntity>> getWallets() async {
    return getIt<WalletService>().getWallets(FirebaseAuth.instance.currentUser?.uid);
  }
}
