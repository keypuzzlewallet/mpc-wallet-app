import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/models/data/coin_data.dart';
import 'package:mobileapp/screens/v1/views/receive_fund_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/wallets_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveFundScreen extends StatefulWidget {
  final BlockchainCoinItem coin;

  ReceiveFundScreen({Key? key, required this.coin}) : super(key: key);

  @override
  _ReceiveFundScreenState createState() => _ReceiveFundScreenState();
}

class _ReceiveFundScreenState extends State<ReceiveFundScreen> {
  late ThemeData theme;
  late ReceiveFundController controller;

  CoinData? selectedBlockchain;

  _ReceiveFundScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = ReceiveFundController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ReceiveFundController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: FxText.titleLarge("Receive"),
              leading: InkWell(
                  onTap: () {
                    controller.goBack();
                  },
                  child: const Icon(AppIcons.back)),
            ),
            body: BlocSelector<AppGlobalBloc, AppGlobalState, WalletsState>(
              selector: (state) => state.walletsState,
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: FxSpacing.fromLTRB(
                        20, FxSpacing.safeAreaTop(context), 20, 0),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: FxSpacing.nTop(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                Column(
                                  children: [
                                    QrImage(
                                      data: controller.getSelectedAddress(
                                          state,
                                          widget.coin.blockchainConfig
                                              .blockchain),
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        child: FxText.labelMedium(
                                            controller.getSelectedAddress(
                                                state,
                                                widget.coin.blockchainConfig
                                                    .blockchain)),
                                      ),
                                    ),
                                  ],
                                ),
                                FxSpacing.height(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FxButton.medium(
                                        elevation: 0,
                                        borderRadiusAll: Constant.containerRadius.xs,
                                        onPressed: () => controller.copyAddress(
                                            controller.getSelectedAddress(
                                                state,
                                                widget.coin.blockchainConfig
                                                    .blockchain)),
                                        child: FxText.bodyMedium("Copy Address",
                                            fontWeight: 600,
                                            color:
                                            theme.colorScheme.onPrimary)),
                                    IconButton(
                                        onPressed: () => controller.openExplorer(widget.coin.blockchainConfig,                                             controller.getSelectedAddress(
                                            state,
                                            widget.coin.blockchainConfig
                                                .blockchain)),
                                        icon: const Icon(AppIcons.openNew, size: 26))                                  ],
                                ),
                                FxSpacing.height(20),
                                FxText.bodyMedium(
                                  "Note: Only send ${widget.coin.coinConfig.coin.name} to this address on ${widget.coin.blockchainConfig.blockchainName} network. Sending any other coin or token to this address may result in the loss of your deposit.",
                                  color:
                                  theme.colorScheme.error,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
