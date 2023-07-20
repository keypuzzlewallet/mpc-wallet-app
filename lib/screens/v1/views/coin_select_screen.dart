import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/screens/v1/views/coin_select_controller.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class CoinSelectScreen extends StatefulWidget {
  final bool onlyEnabledCoin;

  const CoinSelectScreen({Key? key, required this.onlyEnabledCoin})
      : super(key: key);

  @override
  _CoinSelectScreenState createState() => _CoinSelectScreenState();
}

class _CoinSelectScreenState extends State<CoinSelectScreen> {
  late ThemeData theme;
  late CoinSelectController controller;

  _CoinSelectScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = CoinSelectController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CoinSelectController>(
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
            body: BlocSelector<AppGlobalBloc, AppGlobalState,
                    List<EnabledBlockchain>?>(
                selector: (state) =>
                    state.walletsState.defaultWallet?.enabledBlockchains,
                builder: (context, enabledBlockchains) =>
                    list2(enabledBlockchains)),
          );
        });
  }

  Widget list2(List<EnabledBlockchain>? enabledBlockchains) {
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
          children: _buildList(enabledBlockchains),
        ),
      ],
    );
  }

  _buildList(List<EnabledBlockchain>? enabledBlockchains) {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (BlockchainCoinItem item in controller.search(controller.items)) {
      if (widget.onlyEnabledCoin) {
        if (enabledBlockchains == null) {
          continue;
        }
        if (!enabledBlockchains.any((element) =>
            element.blockchain == item.blockchainConfig.blockchain)) {
          continue;
        }
        if (!enabledBlockchains
            .firstWhere((element) =>
                element.blockchain == item.blockchainConfig.blockchain)
            .coins
            .any((element) => element == item.coinConfig.coin)) {
          continue;
        }
      }
      list.add(_buildSingle(item));
    }
    return list;
  }

  Widget _buildSingle(BlockchainCoinItem item) {
    return FxContainer(
      onTap: () => controller.selectCoin(item),
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
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.colorScheme.onBackground,
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
