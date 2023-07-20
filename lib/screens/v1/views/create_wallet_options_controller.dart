import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/screens/v1/views/create_new_wallet_screen.dart';
import 'package:mobileapp/screens/v1/views/create_wallet_options_screen.dart';
import 'package:mobileapp/services/kbus.dart';

class CreateWalletOptionsController extends FxController {
  CreateWalletOptionsController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "create_wallet_options_controller";
  }

  void goBack() {
    Navigator.pop(context, "");
  }

  createWallet(WalletCreationConfig config) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNewWalletScreen(
            numberOfRequiredSignatures: config.t + 1,
            numberOfMembers: config.n,
            isHotSigningWallet: config.isOnline,
            walletTypeName: config.name),
      ),
    );
  }
}
