import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/security_settings_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({Key? key}) : super(key: key);

  @override
  _SecuritySettingsScreenState createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  late ThemeData theme;
  late SecuritySettingsController controller;

  _SecuritySettingsScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = SecuritySettingsController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SecuritySettingsController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: FxText.titleLarge("Security Settings"),
              centerTitle: true,
            ),
            body: BlocSelector<AppGlobalBloc, AppGlobalState, SettingsState>(
              selector: (state) {
                return state.settingsState;
              },
              builder: (context, settingsState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: FxSpacing.fromLTRB(
                        20, FxSpacing.safeAreaTop(context), 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SwitchListTile(
                              title: FxText.bodyMedium(
                                "Turn on hot wallet",
                              ),
                              subtitle: FxText.bodySmall(
                                "Hot wallet will allow you to send and receive funds without using QR codes. But It will connect to the internet.",
                              ),
                              onChanged: (value) {
                                if (value == true) {
                                  _showDialog(value);
                                } else {
                                  controller.updateHotWalletDevice(value);
                                }
                              },
                              value: settingsState.isHotWallet,
                            ),
                            const Divider(),
                            SwitchListTile(
                              title: FxText.bodyMedium(
                                "Whitelisted Addresses",
                              ),
                              subtitle: FxText.bodySmall(
                                "Only allow to withdraw funds to whitelisted addresses.",
                              ),
                              onChanged: (value) => setState(() {
                                controller.updateWhitelistedAddress(value);
                              }),
                              value: settingsState.whitelisted,
                            ),
                            const Divider(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  void _showDialog(bool value) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Container(
                padding: FxSpacing.all(20),
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
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: FxText.titleLarge("Hot Wallet",
                                fontWeight: 600),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Container(
                      margin: FxSpacing.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                            style: FxTextStyle.titleSmall(
                                fontWeight: 600, letterSpacing: 0.2),
                            children: const <TextSpan>[
                              TextSpan(
                                text:
                                    "Are you sure you want to turn your wallet to hot wallet? You need to restart the app to apply the changes.",
                              ),
                            ]),
                      ),
                    ),
                    Container(
                        margin: FxSpacing.top(24),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FxButton.text(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: FxText.bodyMedium(
                                  "No",
                                  fontWeight: 600,
                                  color: theme.colorScheme.primary,
                                )),
                            FxButton.medium(
                                backgroundColor: theme.colorScheme.primary,
                                borderRadiusAll: 4,
                                elevation: 0,
                                onPressed: () {
                                  setState(() {
                                    controller.updateHotWalletDevice(value);
                                    Navigator.pop(context);
                                  });
                                },
                                child: FxText.bodyMedium("Yes",
                                    fontWeight: 600,
                                    color: theme.colorScheme.onPrimary)),
                          ],
                        )),
                  ],
                ),
              ),
            ));
  }

  Widget singleRow(
      IconData icon, String title, String subTitle, VoidCallback onTap) {
    return Padding(
      padding: FxSpacing.bottom(8),
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            FxContainer.rounded(
              paddingAll: 12,
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            FxSpacing.width(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodyMedium(
                    title,
                    fontWeight: 600,
                  ),
                  FxSpacing.height(2),
                  FxText.bodySmall(subTitle),
                ],
              ),
            ),
            FxSpacing.width(20),
            const Icon(
              AppIcons.forward,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
