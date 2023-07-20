import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/data/coin_data.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/wallet_controller.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/wallets_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late ThemeData theme;
  late WalletController controller;

  _WalletScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = WalletController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if ((await getIt<WalletService>()
              .getWallets(FirebaseAuth.instance.currentUser?.uid))
          .isEmpty) {
        showDialog(
            context: context, builder: (BuildContext context) => buildPopup());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<WalletController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: FxText.titleLarge("Wallet"),
              centerTitle: true,
            ),
            floatingActionButton:
                BlocSelector<AppGlobalBloc, AppGlobalState, WalletEntity?>(
              selector: (state) => state.walletsState.defaultWallet,
              builder: (context, defaultWallet) {
                return defaultWallet != null
                    ? FloatingActionButton(
                        onPressed: () =>
                            controller.goToCoinManagement(defaultWallet),
                        elevation: 2,
                        child: const Icon(AppIcons.edit),
                      )
                    : const SizedBox.shrink();
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context), 20, 70),
                child:
                    BlocSelector<AppGlobalBloc, AppGlobalState, WalletsState>(
                  selector: (state) => state.walletsState,
                  builder: (context, walletState) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FxText.titleLarge(
                                controller.calculateBalance(walletState),
                                fontWeight: 700),
                            FxSpacing.width(10),
                            BlocSelector<AppGlobalBloc, AppGlobalState,
                                SettingsState>(
                              selector: (state) {
                                return state.settingsState;
                              },
                              builder: (context, settingsState) {
                                return !settingsState.isHotWallet
                                    ? Tooltip(
                                        message: "Cold Wallet",
                                        child: Icon(AppIcons.wallet,
                                            color: theme.colorScheme.primary),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        FxText.bodyMedium(
                          walletState.defaultWallet?.name ?? "-",
                          fontWeight: 600,
                          xMuted: true,
                        ),
                        FxSpacing.height(20),
                        currencyView(walletState.defaultWallet),
                        FxSpacing.height(20),
                        balanceView(walletState.defaultWallet),
                        FxSpacing.height(20),
                        BlocSelector<AppGlobalBloc, AppGlobalState,
                                List<CoinData>>(
                            selector: (state) => state.walletsState.coins ?? [],
                            builder: (context, state) => BlocSelector<
                                    AppGlobalBloc,
                                    AppGlobalState,
                                    SettingsState>(
                                  selector: (state) => state.settingsState,
                                  builder: (context, settings) {
                                    return coinsView(
                                        settings.isHotWallet, state);
                                  },
                                )),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Widget coinsView(bool isHotWallet, List<CoinData> coins) {
    List<Widget> list = coins
        .map((e) => FxContainer.bordered(
              onTap: () {
                controller.goToSingleCoinScreen();
              },
              paddingAll: 12,
              margin: FxSpacing.bottom(20),
              borderRadiusAll: Constant.containerRadius.small,
              color: theme.scaffoldBackgroundColor,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/coins/${e.coin.name.toLowerCase()}.svg",
                    height: 32,
                    width: 32,
                  ),
                  FxSpacing.width(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.bodyMedium(e.coin.name),
                        FxSpacing.height(4),
                        FxText.bodyMedium(
                          shortAddress(e.address, size: 8),
                          fontWeight: 700,
                        ),
                      ],
                    ),
                  ),
                  FxText.bodyMedium(
                    "${isHotWallet ? (e.balance != null ? formatNumber(e.balance!) : "~") : "N/A"} ${e.coin.name}",
                    fontWeight: 700,
                  ),
                ],
              ),
            ))
        .toList();
    return Column(
      children: list,
    );
  }

  Widget currencyView(WalletEntity? defaultWallet) {
    return BlocSelector<AppGlobalBloc, AppGlobalState, SettingsState>(
      selector: (state) => state.settingsState,
      builder: (context, settingsState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FxButton.medium(
              borderRadiusAll: Constant.containerRadius.xs,
              elevation: 0,
              disabled: defaultWallet == null,
              onPressed: () => controller.goToReceive(),
              child: Row(
                children: [
                  const Icon(
                    AppIcons.receiveFund,
                    size: 20,
                  ),
                  FxSpacing.width(5),
                  FxText(
                    "Receive",
                    fontWeight: 600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
            FxButton.medium(
              borderRadiusAll: Constant.containerRadius.xs,
              disabled: defaultWallet == null,
              elevation: 0,
              onPressed: () =>
                  controller.goToWithdrawScreen(settingsState.whitelisted),
              child: Row(
                children: [
                  const Icon(
                    AppIcons.withdrawFund,
                    size: 20,
                  ),
                  FxSpacing.width(5),
                  FxText(
                    "Send",
                    fontWeight: 600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget balanceView(WalletEntity? wallet) {
    return FxContainer.bordered(
      borderRadiusAll: Constant.containerRadius.small,
      color: theme.scaffoldBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodySmall(
                  "Wallet ID",
                  xMuted: true,
                  fontWeight: 600,
                ),
                FxText.bodyMedium(
                  wallet?.walletId ?? "-",
                  fontWeight: 700,
                ),
                FxSpacing.height(10),
                Row(
                  children: [
                    Icon(
                      AppIcons.members,
                      color: theme.colorScheme.onBackground.withAlpha(200),
                      size: 16,
                    ),
                    FxText.bodyMedium(
                      wallet?.noMembers.toString() ?? "0",
                    ),
                    FxSpacing.width(20),
                    Icon(
                      AppIcons.requiredSigners,
                      color: theme.colorScheme.onBackground.withAlpha(200),
                      size: 16,
                    ),
                    FxText.bodyMedium(
                      ((wallet?.threshold ?? 0) + 1).toString(),
                    ),
                  ],
                ),
                // FxSpacing.height(16),
                // balanceType(),
              ],
            ),
          ),
          FxButton.medium(
            borderRadiusAll: Constant.containerRadius.xs,
            elevation: 0,
            onPressed: () => controller.goToSwitchWallet(),
            child: const Icon(
              AppIcons.changeWallet,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget balanceType() {
    List<Widget> list = [];
    return Row(
      children: list,
    );
  }

  Widget buildPopup() {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(
                    AppIcons.wallet,
                    size: 28,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const Expanded(
                  child: Text(
                      "You don't have any wallet. Do you want to create one?"),
                )
              ],
            ),
            FxSpacing.height(16),
            Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FxButton.text(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: FxText.bodyMedium("Do it later",
                            fontWeight: 600,
                            color: theme.colorScheme.primary,
                            letterSpacing: 0.4)),
                    FxSpacing.width(16),
                    FxButton.medium(
                        elevation: 2,
                        borderRadiusAll: 4,
                        onPressed: () => controller.goToCreateWallet(),
                        child: FxText.bodyMedium("Create Wallet",
                            fontWeight: 600,
                            letterSpacing: 0.4,
                            color: theme.colorScheme.onPrimary)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
