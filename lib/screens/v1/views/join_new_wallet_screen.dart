import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/join_new_wallet_controller.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class JoinNewWalletScreen extends StatefulWidget {
  const JoinNewWalletScreen({Key? key}) : super(key: key);

  @override
  _JoinNewWalletScreenState createState() => _JoinNewWalletScreenState();
}

class _JoinNewWalletScreenState extends State<JoinNewWalletScreen> {
  late ThemeData theme;
  late JoinNewWalletController controller;

  _JoinNewWalletScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = JoinNewWalletController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<JoinNewWalletController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: FxText.titleLarge("Sign new wallet"),
              elevation: 0,
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
                  child: Container(
                    padding: FxSpacing.nTop(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: FxTextField(
                            labelText: "Session Details",
                            maxLines: 4,
                            autofocus: true,
                            icon: const Icon(AppIcons.newWallet),
                            onChanged: (value) =>
                                controller.updateKeygenSharingJson(value),
                            suffixIcon: IconButton(
                              icon: const Icon(AppIcons.qrScanner),
                              onPressed: () => controller.scan(),
                            ),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      theme.colorScheme.primary.withAlpha(28),
                                  blurRadius: 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: FxButton.medium(
                                elevation: 0,
                                borderRadiusAll: Constant.containerRadius.xs,
                                onPressed: () => controller.submit(),
                                child: FxText.labelMedium("Join",
                                    fontWeight: 700,
                                    color: theme.colorScheme.onPrimary)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      theme.colorScheme.primary.withAlpha(28),
                                  blurRadius: 4,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
