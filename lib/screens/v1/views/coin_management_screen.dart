import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/coin_management_controller.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/wallets_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class CoinManagementScreen extends StatefulWidget {
  const CoinManagementScreen({Key? key}) : super(key: key);

  @override
  _CoinManagementScreenState createState() => _CoinManagementScreenState();
}

class _CoinManagementScreenState extends State<CoinManagementScreen> {
  late ThemeData theme;
  late CoinManagementController controller;

  _CoinManagementScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = CoinManagementController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CoinManagementController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: FxText.titleLarge("Coins"),
              centerTitle: true,
              elevation: 0,
              actions: const [],
            ),
            body: BlocSelector<AppGlobalBloc, AppGlobalState, WalletsState>(
                selector: (walletState) => walletState.walletsState,
                builder: (context, walletState) =>
                    list2(walletState.defaultWallet)),
          );
        });
  }

  Widget list2(WalletEntity? wallet) {
    return ListView(
      padding: FxSpacing.horizontal(
        24,
      ),
      children: [
        FxTextField(
          onChanged: (value) => setState(() {
            controller.searchChanged(value);
          }),
          textFieldStyle: FxTextFieldStyle.outlined,
          labelText: 'Search coins',
          focusedBorderColor: theme.primaryColor,
          cursorColor: theme.focusColor,
          labelStyle: FxTextStyle.bodySmall(
              color: theme.colorScheme.onBackground, xMuted: true),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: theme.focusColor.withAlpha(40),
          suffixIcon: Icon(
            AppIcons.search,
            color: theme.primaryColor,
            size: 20,
          ),
        ),
        FxSpacing.height(20),
        Column(
          children: wallet != null ? _buildList(wallet) : [],
        ),
      ],
    );
  }

  _buildList(WalletEntity wallet) {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (BlockchainCoinItem item in controller.search(controller.items)) {
      list.add(_buildSingle(wallet, item));
    }
    return list;
  }

  Widget _buildSingle(WalletEntity wallet, BlockchainCoinItem item) {
    return FxContainer(
      margin: FxSpacing.bottom(8),
      paddingAll: 8,
      borderRadiusAll: 16,
      child: Row(
        children: [
          FxContainer.rounded(
            paddingAll: 0,
            child: SvgPicture.asset(
              "assets/coins/${getIt<CurrencyConfig>().findCoinConfig(item.blockchainConfig.blockchain, item.coinConfig.coin)?.coin.name.toLowerCase() ?? "unknown"}.svg",
              height: 32,
              width: 32,
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FxText.bodyMedium(
                      item.coinConfig.coinName,
                      fontWeight: 600,
                    ),
                  ],
                ),
                FxSpacing.height(4),
                !item.coinConfig.isNative
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            "assets/blockchains/${item.blockchainConfig.blockchain.name.toLowerCase()}.svg",
                            height: 16,
                            width: 16,
                          ),
                          FxSpacing.width(4),
                          FxText.bodySmall(
                            item.blockchainConfig.blockchainName,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          FxSpacing.width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Switch(
                value: controller.getSwitchValue(wallet, item),
                onChanged: (bool value) {
                  setState(() {
                    controller.coinSelected(wallet, item, value);
                  });
                  ;
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Expanded smartContractListItem(SigningRequest session) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FxSpacing.width(4),
              FxText.bodyMedium(
                "Call ${session.ethSmartContractRequest!.amount} ${session.coin.name}",
                fontWeight: 600,
              ),
            ],
          ),
          FxSpacing.height(4),
          Row(children: [
            FxText.bodySmall(
              shortAddress(session.fromAddress),
            ),
            const Icon(AppIcons.goTo),
            FxText.bodySmall(
              shortAddress(session.ethSmartContractRequest!.toAddress),
            ),
          ]),
        ],
      ),
    );
  }
}
