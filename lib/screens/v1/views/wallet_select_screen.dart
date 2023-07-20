import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/components/wallet_list_item.dart';
import 'package:mobileapp/screens/v1/views/wallet_select_controller.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class WalletSelectScreen extends StatefulWidget {
  final String title;

  const WalletSelectScreen({Key? key, required this.title}) : super(key: key);

  @override
  _WalletSelectScreenState createState() => _WalletSelectScreenState();
}

class _WalletSelectScreenState extends State<WalletSelectScreen> {
  late ThemeData theme;
  late WalletSelectController controller;

  _WalletSelectScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = WalletSelectController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<WalletSelectController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: FxText.titleLarge(widget.title),
                leading: InkWell(
                    onTap: () {
                      controller.goBack();
                    },
                    child: const Icon(AppIcons.back)),
              ),
              body: EnhancedFutureBuilder(
                  future: controller.getWallets(),
                  rememberFutureResult: false,
                  whenNotDone: const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                  whenDone: (wallets) => ListView(
                      padding: FxSpacing.x(16),
                      children: wallets
                          .map((wallet) => InkWell(
                                onTap: () => controller.onSelectWallet(wallet),
                                child: Container(
                                    margin: FxSpacing.top(0),
                                    child: walletListItem(wallet)),
                              ))
                          .toList())));
        });
  }
}
