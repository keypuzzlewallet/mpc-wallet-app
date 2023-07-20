import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/select_default_wallet.dart';
import 'package:mobileapp/events/enums/fiat.dart';
import 'package:mobileapp/events/pricefeed/coin_price.dart';
import 'package:mobileapp/events/pricefeed/coin_price_item.dart';
import 'package:mobileapp/events/pricefeed/fiat_config.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/coin_management_screen.dart';
import 'package:mobileapp/screens/v1/views/coin_select_screen.dart';
import 'package:mobileapp/screens/v1/views/create_new_signing_screen.dart';
import 'package:mobileapp/screens/v1/views/create_wallet_options_screen.dart';
import 'package:mobileapp/screens/v1/views/receive_fund_screen.dart';
import 'package:mobileapp/screens/v1/views/wallet_select_screen.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/states/wallets_state.dart';

class WalletController extends FxController {
  WalletController();

  @override
  void initState() async {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  goToCreateWallet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateWalletOptionsScreen(),
      ),
    );
  }

  void goToSingleCoinScreen() {}

  @override
  String getTag() {
    return "wallet_controller";
  }

  goToSwitchWallet() async {
    WalletEntity? wallet = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WalletSelectScreen(title: "Switch Wallet"),
      ),
    );
    if (wallet != null) {
      getIt<KbusClient>().fireE(this, SelectDefaultWallet(wallet));
    }
  }

  goToWithdrawScreen(bool isOnlyWhitelisted) async {
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

  goToReceive() async {
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
        builder: (context) => ReceiveFundScreen(coin: coinItem),
      ),
    );
  }

  goToCoinManagement(WalletEntity wallet) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CoinManagementScreen(),
      ),
    );
    WalletEntity? updatedWallet =
        await getIt<WalletService>().getWalletById(wallet.walletId);
    if (updatedWallet != null) {
      getIt<KbusClient>().action(this, SelectDefaultWallet(updatedWallet));
    }
    getIt<KbusClient>().action(this, ControllerLoaded(context, getTag()));
  }

  String calculateBalance(WalletsState walletState) {
    FiatConfig fiat = getIt<CurrencyConfig>().fiatConfigs[Fiat.USD]!;
    if (walletState.coins == null || walletState.prices == null) {
      return "${fiat.symbol}0";
    }
    BigDecimal balance = BigDecimal.parse("0");
    walletState.coins!.forEach((coin) {
      if (coin.balance == null || coin.balance == 0) {
        return;
      }
      List<CoinPrice> prices = walletState.prices!
          .where((element) => element.coin == coin.coin)
          .toList();
      if (prices.isNotEmpty) {
        CoinPrice price = prices.first;
        List<CoinPriceItem> priceItems = price.coinPriceItems
            .where((element) => element.fiat == fiat.fiat)
            .toList();
        if (priceItems.isNotEmpty) {
          balance = balance + (priceItems.first.price * coin.balance!);
        }
      }
    });
    return "${fiat.symbol}${formatNumber(balance, size: 2)}";
  }
}
