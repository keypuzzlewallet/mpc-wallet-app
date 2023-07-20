import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:mobileapp/events/blockchain/config/blockchain_coin_config.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';
import 'package:mobileapp/events/blockchain/config/coin_config.dart';
import 'package:mobileapp/events/blockchain/config/config_for_blockchain.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/enums/fiat.dart';
import 'package:mobileapp/events/pricefeed/fiat_config.dart';

class CurrencyConfig {
  Map<Blockchain, BlockchainConfig> blockchainConfigs = {};
  Map<Coin, CoinConfig> coinConfigs = {};
  Map<Fiat, FiatConfig> fiatConfigs = {};

  BlockchainCoinConfig? findCoinConfig(Blockchain blockchain, Coin coin) {
    var coinConfig = coinConfigs[coin];
    if (coinConfig == null) {
      return null;
    }
    List<ConfigForBlockchain> configForBlockchain = coinConfig
        .configForBlockchain
        .where((element) => element.blockchain == blockchain)
        .toList();
    if (configForBlockchain.isEmpty) {
      return null;
    }
    return BlockchainCoinConfig(
      coin: coin,
      decimals: coinConfig.configForBlockchain[0].decimals,
      blockchain: blockchain,
      coinName: coinConfig.coinName,
      enabled: coinConfig.configForBlockchain[0].enabled,
      flags: coinConfig.configForBlockchain[0].flags,
      isNative: coinConfig.configForBlockchain[0].isNative,
      priceFeedId: coinConfig.priceFeedId,
      contractAddress: coinConfig.configForBlockchain[0].contractAddress,
    );
  }

  List<BlockchainCoinConfig> findCoinInBlockchain(Blockchain blockchain) {
    return coinConfigs.values
        .map((coinConfig) {
          List<ConfigForBlockchain> configForBlockchain = coinConfig
              .configForBlockchain
              .where((element) => element.blockchain == blockchain)
              .toList();
          if (configForBlockchain.isEmpty) {
            return null;
          }
          return BlockchainCoinConfig(
            coin: coinConfig.coin,
            decimals: coinConfig.configForBlockchain[0].decimals,
            blockchain: blockchain,
            coinName: coinConfig.coinName,
            enabled: coinConfig.configForBlockchain[0].enabled,
            flags: coinConfig.configForBlockchain[0].flags,
            isNative: coinConfig.configForBlockchain[0].isNative,
            priceFeedId: coinConfig.priceFeedId,
            contractAddress: coinConfig.configForBlockchain[0].contractAddress,
          );
        })
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  }

// function to load currencies.yml file into currencyConfigs
  init() async {
    if (blockchainConfigs.isNotEmpty) {
      // in dev mode, this may load multiple time due to hot reload
      return;
    }
    String jsonString = await rootBundle.loadString('currencies.json');
    Map<String, dynamic> json = jsonDecode(jsonString);
    // load fiats
    List<dynamic> fiatData = json["fiats"];
    fiatData.forEach((data) => fiatConfigs.putIfAbsent(
        Fiat.values.firstWhere((element) => element.name == data["fiat"]),
        () => FiatConfig.fromJson(data)));

    // load blockchains
    List<dynamic> blockchainData = json["blockchains"];
    blockchainData.forEach((data) => blockchainConfigs.putIfAbsent(
        Blockchain.values
            .firstWhere((element) => element.name == data["blockchain"]),
        () => BlockchainConfig.fromJson(data)));

    // load coins
    List<dynamic> coinData = json["coins"];
    coinData.forEach((data) => coinConfigs.putIfAbsent(
        Coin.values.firstWhere((element) => element.name == data["coin"]),
        () => CoinConfig.fromJson(data)));
  }
}
