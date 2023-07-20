import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/states/wallets_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiveFundController extends FxController {
  ReceiveFundController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "receive_fund_controller";
  }

  void goBack() {
    Navigator.pop(context);
  }

  copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
  }

  getSelectedAddress(WalletsState state, Blockchain blockchain) {
    return (state.coins ?? [])
        .firstWhere((element) => element.blockchain == blockchain)
        .address;
  }

  openExplorer(BlockchainConfig blockchainConfig, String address) {
    launchUrl(Uri.parse(blockchainConfig.addressExplorer.replaceFirst("{address}", address)));
  }
}
