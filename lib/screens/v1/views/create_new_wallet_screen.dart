import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/create_new_wallet_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class CreateNewWalletScreen extends StatefulWidget {
  final int numberOfRequiredSignatures;
  final int numberOfMembers;
  final bool isHotSigningWallet;
  final String walletTypeName;
  const CreateNewWalletScreen({Key? key,
    required this.numberOfRequiredSignatures,
    required this.numberOfMembers,
    required this.isHotSigningWallet,
    required this.walletTypeName,}) : super(key: key);

  @override
  _CreateNewWalletScreenState createState() => _CreateNewWalletScreenState();
}

class _CreateNewWalletScreenState extends State<CreateNewWalletScreen> {
  late ThemeData theme;
  late CreateNewWalletController controller;

  _CreateNewWalletScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = CreateNewWalletController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CreateNewWalletController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: FxText.titleLarge(widget.walletTypeName),
              leading: InkWell(
                  onTap: () {
                    controller.goBack();
                  },
                  child: const Icon(AppIcons.back)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context), 20, 0),
                child: SingleChildScrollView(
                  child: BlocSelector<AppGlobalBloc, AppGlobalState,
                      SettingsState>(
                    selector: (state) => state.settingsState,
                    builder: (context, settingsState) {
                      return Container(
                        padding: FxSpacing.nTop(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: FxTextField(
                                labelText: "Wallet name",
                                icon: const Icon(AppIcons.wallet),
                                onChanged: (value) =>
                                    controller.updateWalletName(value),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: FxTextField(
                                labelText: "Your nick name",
                                icon: const Icon(AppIcons.aliasName),
                                onChanged: (value) =>
                                    controller.updateNickName(value),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withAlpha(28),
                                      blurRadius: 4,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: FxButton.medium(
                                    elevation: 0,
                                    borderRadiusAll: Constant.containerRadius.xs,
                                    onPressed: () => controller.submit(widget.numberOfRequiredSignatures, widget.numberOfMembers, widget.isHotSigningWallet),
                                    child: FxText.labelMedium("Create Session",
                                        fontWeight: 700,
                                        color: theme.colorScheme.onPrimary)),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
