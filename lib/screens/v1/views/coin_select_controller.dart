import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_service.dart';

class CoinSelectController extends FxController {
  String searchKeyword = "";
  List<BlockchainCoinItem> items = [];

  CoinSelectController();

  @override
  void initState() {
    super.initState();
    getIt<CurrencyConfig>().blockchainConfigs.values.forEach((b) {
      if (b.enabled) {
        getIt<CurrencyConfig>().findCoinInBlockchain(b.blockchain).forEach((c) {
          if (c.enabled) {
            items.add(BlockchainCoinItem(b, c));
          }
        });
      }
    });
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  void goBack(WalletEntity wallet) {
    Navigator.pop(context);
  }

  @override
  String getTag() {
    return "coin_select_controller";
  }

  coinSelected(WalletEntity wallet, BlockchainCoinItem item, bool enabled) {
    if (enabled) {
      List<EnabledBlockchain> blockchains = wallet.enabledBlockchains
          .where((element) =>
              element.blockchain == item.blockchainConfig.blockchain)
          .toList();
      if (blockchains.isEmpty) {
        wallet.enabledBlockchains.add(EnabledBlockchain(
            blockchain: item.blockchainConfig.blockchain,
            coins: [item.coinConfig.coin]));
      } else {
        blockchains[0].coins.add(item.coinConfig.coin);
      }
      getIt<WalletService>().updateWalletEnabledBlockchains(
          wallet.walletId, wallet.enabledBlockchains);
    } else {
      List<EnabledBlockchain> blockchains = wallet.enabledBlockchains
          .where((element) =>
              element.blockchain == item.blockchainConfig.blockchain)
          .toList();
      if (blockchains.isNotEmpty) {
        blockchains[0].coins.remove(item.coinConfig.coin);
      }
      getIt<WalletService>().updateWalletEnabledBlockchains(
          wallet.walletId, wallet.enabledBlockchains);
    }
  }

  searchChanged(String value) {
    searchKeyword = value;
  }

  List<BlockchainCoinItem> search(List<BlockchainCoinItem> items) {
    if (searchKeyword.isEmpty) {
      return items;
    }
    return items
        .where((element) => element
            .toString()
            .toLowerCase()
            .contains(searchKeyword.toLowerCase()))
        .toList();
  }

  bool getSwitchValue(WalletEntity wallet, BlockchainCoinItem item) {
    var enabledBlockchain = wallet.enabledBlockchains
        .where(
            (element) => element.blockchain == item.blockchainConfig.blockchain)
        .toList();
    if (enabledBlockchain.isEmpty) {
      return false;
    }
    return enabledBlockchain[0]
            .coins
            .indexWhere((element) => element == item.coinConfig.coin) >=
        0;
  }

  selectCoin(BlockchainCoinItem item) {
    Navigator.of(context).pop(item);
  }
}
