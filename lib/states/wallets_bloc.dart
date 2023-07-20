import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/reload_wallet.dart';
import 'package:mobileapp/actions/select_default_wallet.dart';
import 'package:mobileapp/actions/send_command.dart';
import 'package:mobileapp/blockchainlibs/blockchain_lib.dart';
import 'package:mobileapp/events/bitcoinworker/wallet_balance_update.dart';
import 'package:mobileapp/events/blockchain/message/get_address_request.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/pricefeed/coin_prices.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/events/wallet/client_wallet_loaded.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/models/data/coin_data.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/common_bloc.dart';
import 'package:mobileapp/states/sub_bloc.dart';
import 'package:mobileapp/states/wallets_state.dart';

class WalletsBloc extends SubBloc {
  final KbusClient kbus;
  final WalletService walletService;
  final CommonBloc commonBloc;
  final BlockchainLib blockchainLib;

  WalletsBloc(super.getState, super.emit, super.setContext, super.getContext,
      this.kbus, this.walletService, this.commonBloc, this.blockchainLib) {
    kbus.onE<ReloadWallet>(this).listen((event) => _handleReloadWallets(event));
    kbus
        .onE<ControllerLoaded>(this)
        .listen((event) => _handleControllerFetchData(event));
    kbus
        .onE<SelectDefaultWallet>(this)
        .listen((event) => _handleDefaultWallet(event));
    kbus
        .onE<WalletBalanceUpdate>(this)
        .listen((event) => _handleBalanceUpdate(event));
    kbus
        .onE<CoinPrices>(this)
        .listen((event) => _handleCoinPricesUpdate(event));
  }

  Future<void> _handleReloadWallets(event) async {
    if (getState().walletsState.defaultWallet != null) {
      kbus.fireE(
          this,
          SendCommand(
              command: ClientWalletLoaded(
            enabledBlockchains:
                getState().walletsState.defaultWallet!.enabledBlockchains,
            walletConfig: WalletCreationConfig(
              pubkeys: getState().walletsState.defaultWallet!.pubkeys,
              isMainnet: getState()
                  .walletsState
                  .defaultWallet!
                  .walletCreationConfig
                  .isMainnet,
              isSegwit: getState()
                  .walletsState
                  .defaultWallet!
                  .walletCreationConfig
                  .isSegwit,
            ),
          )));
    } else {
      await commonBloc.handleAlert(
          Alert(level: AlertLevel.ERROR, message: "Not found default wallet"));
    }
  }

  _handleDefaultWallet(SelectDefaultWallet event) async {
    List<CoinData> coinData = [];
    for (var b in event.wallet.enabledBlockchains) {
      for (var c in b.coins) {
        var address = "";
        try {
          address = blockchainLib
              .getAddress(GetAddressRequest(
                  blockchain: b.blockchain,
                  coin: c,
                  walletConfig: WalletCreationConfig(
                      pubkeys: event.wallet.pubkeys,
                      isMainnet: event.wallet.walletCreationConfig.isMainnet,
                      isSegwit: event.wallet.walletCreationConfig.isSegwit)))
              .address;
        } catch (e, stacktrace) {
          print(stacktrace);
          commonBloc.handleAlert(Alert(
              level: AlertLevel.ERROR,
              message: "Error getting address for $c in ${b.blockchain}"));
        }
        coinData.add(CoinData(b.blockchain, c, address, null));
      }
    }
    emit(getState().copyWith(
        walletsState: getState()
            .walletsState
            .copyWith(defaultWallet: event.wallet, coins: coinData)));

    kbus.fireE(
        this,
        SendCommand(
            command: ClientWalletLoaded(
                enabledBlockchains: event.wallet.enabledBlockchains,
                walletConfig: WalletCreationConfig(
                    pubkeys: event.wallet.pubkeys,
                    isMainnet: event.wallet.walletCreationConfig.isMainnet,
                    isSegwit: event.wallet.walletCreationConfig.isSegwit))));

    commonBloc.handleAlert(Alert(
        level: AlertLevel.INFO, message: "Wallet ${event.wallet.name} loaded"));
  }

  _handleControllerFetchData(ControllerLoaded event) async {
    setContext(event.context);
    if ((event.controllerTag == "wallet_controller") &&
        getState().walletsState.defaultWallet != null) {
      kbus.fireE(
          this,
          SendCommand(
              command: ClientWalletLoaded(
                  enabledBlockchains:
                      getState().walletsState.defaultWallet!.enabledBlockchains,
                  walletConfig: WalletCreationConfig(
                      pubkeys: getState().walletsState.defaultWallet!.pubkeys,
                      isMainnet: getState()
                          .walletsState
                          .defaultWallet!
                          .walletCreationConfig
                          .isMainnet,
                      isSegwit: getState()
                          .walletsState
                          .defaultWallet!
                          .walletCreationConfig
                          .isSegwit))));
    } else if (event.controllerTag == "switch_wallet_controller") {
      emit(getState().copyWith(
          walletsState: getState().walletsState.copyWith(
              wallets: await walletService
                  .getWallets(FirebaseAuth.instance.currentUser?.uid))));
    }
  }

  _handleBalanceUpdate(WalletBalanceUpdate event) {
    List<CoinData> coinData = [];
    int index = (getState().walletsState.coins ?? []).indexWhere(
        (e) => e.blockchain == event.blockchain && e.coin == event.coin);
    for (var i = 0; i < (getState().walletsState.coins ?? []).length; i++) {
      if (i != index) {
        coinData.add((getState().walletsState.coins ?? [])[i]);
      } else {
        coinData.add(CoinData(event.blockchain, event.coin,
            (getState().walletsState.coins ?? [])[i].address, event.balance));
      }
    }
    emit(getState().copyWith(
        walletsState: getState().walletsState.copyWith(coins: coinData)));
  }

  _handleCoinPricesUpdate(CoinPrices event) {
    emit(getState().copyWith(
        walletsState:
            getState().walletsState.copyWith(prices: event.coinPrices)));
  }
}
