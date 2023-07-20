import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/screens/v1/views/browser_screen.dart';
import 'package:mobileapp/services/kbus.dart';

class AppsDexController extends FxController {
  AppsDexController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "apps_dex_controller";
  }

  openApp(BlockchainConfig blockchain, Coin coin, String link, List<BlockchainConfig> supported) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            BrowserScreen(blockchain: blockchain, coin: coin, mainPage: link, supportedChains: supported),
      ),
    );
  }
}
