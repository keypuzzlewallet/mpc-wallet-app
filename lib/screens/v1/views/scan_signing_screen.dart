import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/scan_signing_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class ScanSigningScreen extends StatefulWidget {
  const ScanSigningScreen({Key? key}) : super(key: key);

  @override
  _ScanSigningScreenState createState() => _ScanSigningScreenState();
}

class _ScanSigningScreenState extends State<ScanSigningScreen> {
  late ThemeData theme;
  late ScanSigningController controller;

  _ScanSigningScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = ScanSigningController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ScanSigningController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: FxText.titleLarge("Sign a transaction"),
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
                child:
                    BlocSelector<AppGlobalBloc, AppGlobalState, SettingsState>(
                  selector: (state) => state.settingsState,
                  builder: (context, settingsState) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: FxSpacing.nTop(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: FxTextField(
                                labelText: "Transaction request",
                                controller:
                                    controller.transactionRequestController,
                                maxLines: 4,
                                autofocus: true,
                                icon: const Icon(AppIcons.qrCode),
                                onChanged: (value) => controller
                                    .onTransactionRequestChangeChanged(value),
                                suffixIcon: IconButton(
                                  icon: const Icon(AppIcons.qrScanner),
                                  onPressed: () => controller.scanQrCode(),
                                ),
                              ),
                            ),
                            FxSpacing.height(20),
                            Center(
                              child: Column(
                                children: [
                                  FxButton.medium(
                                    onPressed: () => controller.sign(),
                                    borderRadiusAll: Constant.containerRadius.xs,
                                    elevation: 0,
                                    child: FxText.labelLarge(
                                      "Sign",
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: 600,
                                    ),
                                  ),
                                  FxSpacing.height(20),
                                  FxButton.medium(
                                    onPressed: () => controller.goToNewRequest(
                                        settingsState.whitelisted),
                                    elevation: 0,
                                    borderRadiusAll: Constant.containerRadius.xs,
                                    backgroundColor: theme.cardTheme.color,
                                    child: FxText.labelLarge(
                                      "Make New Request",
                                      color: theme.colorScheme.onBackground,
                                      fontWeight: 600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // button to go to scan qr code screen
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }
}
