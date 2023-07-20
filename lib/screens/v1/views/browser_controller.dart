import 'dart:math';

import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/blockchainlibs/blockchain_lib.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_coin_config.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';
import 'package:mobileapp/events/blockchain/config/coin_config.dart';
import 'package:mobileapp/events/blockchain/message/get_address_request.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/signing/requests/eth_contract_request.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/browser_screen.dart';
import 'package:mobileapp/screens/v1/views/create_new_signing_screen.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/defibrowser/defi_browser.dart';
import 'package:mobileapp/services/defibrowser/js_bridge_callback_bean.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/utils.dart';

class BrowserController extends FxController {
  InAppWebViewController? webViewController;
  BlockchainConfig blockchain;
  final Coin coin;
  TextEditingController? urlController;

  BrowserController({required this.blockchain, required this.coin});

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "browser_controller";
  }

  goBack() {
    Navigator.of(context).pop();
  }

  void requestSignSmartContract(
      BlockchainConfig blockchain,
      BlockchainCoinConfig? coin,
      String hexGasLimit,
      String hexValue,
      String fromAddress,
      String toAddress,
      String data,
      bool isOnlyWhitelisted) {
    if (coin == null) {
      getIt<KbusClient>().fireE(
          this,
          Alert(
            level: AlertLevel.ERROR,
            message: "Coin not found",
          ));
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateNewSigningScreen(
            blockchainCoinItem: BlockchainCoinItem(
              blockchain,
              coin,
            ),
            isOnlyWhitelisted: isOnlyWhitelisted,
            ethContractRequest: EthContractRequest(
              toAddress: toAddress,
              gasLimit: hexToBigDecimal(hexGasLimit),
              amount: hexToBigDecimal(hexValue).divide(
                  BigDecimal.fromBigInt(BigInt.from(pow(10, 18))),
                  scale: 18),
              data: data,
            )),
      ),
    );
  }

  String getAddress(WalletEntity wallet) {
    return getIt<BlockchainLib>()
        .getAddress(GetAddressRequest(
            blockchain: blockchain.blockchain,
            coin: coin,
            walletConfig: WalletCreationConfig(
                pubkeys: wallet.pubkeys,
                isMainnet: wallet.walletCreationConfig.isMainnet,
                isSegwit: wallet.walletCreationConfig.isSegwit)))
        .address;
  }

  loadUrl(String value) {
    webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse(value)));
  }

  handleSignCallback(Map rawData, EIP1193 eip1193, WalletEntity? wallet,
      bool isOnlyWhitelisted) {
    switch (eip1193) {
      case EIP1193.switchEthereumChain:
        int id = rawData["id"];
        webViewController?.cancel(id);
        break;
      case EIP1193.requestAccounts:
        int id = rawData["id"];
        if (wallet != null) {
          webViewController?.setAddress(getAddress(wallet), id);
        } else {
          webViewController?.cancel(id);
        }
        break;
      case EIP1193.signTransaction:
        // example: [log] calling raw data: {id: 1682212659711, name: signTransaction, object: {gas: 0x34e0e, value: 0x5af3107a4000, from: 0x321aadb023e91684e5ab3784da85a2d60ee2f36e, to: 0x4648a43b2c14da09fdf82b161150d3f634f40491, data: 0x3593564c000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000064448e3700000000000000000000000000000000000000000000000000000000000000020b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000005af3107a40000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000005af3107a4000000000000000000000000000000000000000000000000000000000d1a556ac8100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002b9c3c9283d3e44854697cd22d3faa240cfb032889000064a6fa4fb5f76172d178d61b04b0ecd319c5d1c0aa000000000000000000000000000000000000000000}, network: ethereum}
        requestSignSmartContract(
            getIt<CurrencyConfig>().blockchainConfigs[blockchain.blockchain]!,
            getIt<CurrencyConfig>().findCoinConfig(blockchain.blockchain, coin),
            rawData["object"]["gas"],
            rawData["object"]["value"],
            rawData["object"]["from"],
            rawData["object"]["to"],
            rawData["object"]["data"],
            isOnlyWhitelisted);
        break;
    }
  }

   changeChain(BlockchainConfig chain, List<BlockchainConfig> supportedChains) async {
    var url = await webViewController!.getUrl();
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BrowserScreen(
          blockchain: chain,
          coin: getIt<CurrencyConfig>().findCoinInBlockchain(chain.blockchain).firstWhere((element) => element.isNative).coin,
          mainPage: url.toString(),
          supportedChains: supportedChains,
        ),
      ),
    );
  }
}
