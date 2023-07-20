import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/components/rotate_qr_images.dart';
import 'package:mobileapp/events/enums/keygen_status.dart';
import 'package:mobileapp/screens/v1/views/wait_new_wallet_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/key_generation_mode.dart';
import 'package:mobileapp/states/key_generation_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class WaitNewWalletScreen extends StatefulWidget {
  const WaitNewWalletScreen({Key? key}) : super(key: key);

  @override
  _WaitNewWalletScreenState createState() => _WaitNewWalletScreenState();
}

class _WaitNewWalletScreenState extends State<WaitNewWalletScreen> {
  late ThemeData theme;
  late WaitNewWalletController controller;

  _WaitNewWalletScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = WaitNewWalletController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<WaitNewWalletController>(
      controller: controller,
      theme: theme,
      builder: (controller) {
        return BlocSelector<AppGlobalBloc, AppGlobalState, KeyGenerationState>(
            selector: (state) => state.keyGenerationState,
            builder: (context, keyGenState) {
              return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    centerTitle: true,
                    leading: InkWell(
                      onTap: () => controller.goBack(),
                      child: const Icon(
                        AppIcons.back,
                        size: 20,
                      ),
                    ),
                    title: FxText.titleLarge(
                      keyGenState.mode == KeyGenerationMode.GENERATE_NONCE
                          ? "Generate Pre-signatures"
                          : "Generate Wallet",
                    ),
                    actions: const [],
                  ),
                  body: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: FxContainer(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              EnhancedFutureBuilder(
                                future: controller
                                    .getSharingJoinSession(keyGenState),
                                rememberFutureResult: true,
                                whenNotDone: const SizedBox.shrink(),
                                whenDone: (data) => RotateQrImages(
                                  key: ValueKey(keyGenState),
                                  data: data,
                                  size: 200.0,
                                  length: 150,
                                  duration: const Duration(milliseconds: 250),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  FxText.bodySmall(
                                    "Copy sharing keygen session",
                                  ),
                                  IconButton(
                                      onPressed: () =>
                                          controller.copyKeygenId(keyGenState),
                                      icon: Icon(
                                        AppIcons.copy,
                                        color: theme.colorScheme.primary,
                                        size: 18,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 20, top: 32, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FxText.bodySmall("DETAILS", fontWeight: 600),
                          ],
                        ),
                      ),
                      FxContainer.bordered(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(8),
                        color: Colors.transparent,
                        borderRadiusAll: 4,
                        child: Column(
                          children: <Widget>[
                            _SingleRate(
                              name: 'Wallet Name',
                              value: keyGenState.currentKeygenWalletName ?? "",
                            ),
                            _SingleRate(
                              name: 'Signer Name',
                              value: keyGenState.currentKeygenSignerName ?? "",
                            ),
                            _SingleRate(
                              name: 'Members',
                              value:
                                  keyGenState.numberOfMembers?.toString() ?? "",
                            ),
                            _SingleRate(
                              name: 'Signers',
                              value: keyGenState.numberOfRequiredSignatures
                                      ?.toString() ??
                                  "",
                            ),
                            keyGenState.mode == KeyGenerationMode.GENERATE_NONCE
                                ? _SingleRate(
                                    name: 'Pre-signature Scheme',
                                    value: keyGenState
                                            .generateNonceKeySchema?.name ??
                                        "",
                                  )
                                : const SizedBox.shrink(),
                            keyGenState.mode == KeyGenerationMode.GENERATE_NONCE
                                ? _SingleRate(
                                    name: 'Number of pre-signatures',
                                    value: keyGenState.numberOfNonceToGenerate
                                            ?.toString() ??
                                        "",
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: FxText.bodySmall("ACTIVITY", fontWeight: 600),
                      ),
                      FxContainer.bordered(
                        color: Colors.transparent,
                        margin: const EdgeInsets.all(20),
                        borderRadiusAll: 4,
                        child: Column(
                          children: <Widget>[
                            _SingleRate(
                              name: 'Member Joined',
                              value: keyGenState.status ==
                                      KeygenStatus.KEYGEN_COMPLETED
                                  ? keyGenState.numberOfMembers?.toString() ??
                                      "0"
                                  : controller.joinedMembers.toString(),
                            ),
                            const Divider(
                              thickness: 0.2,
                            ),
                            _SingleRate(
                              name: 'Completion',
                              value: keyGenState.status ==
                                      KeygenStatus.KEYGEN_COMPLETED
                                  ? "100%"
                                  : "${controller.progress}%",
                            ),
                            const Divider(
                              thickness: 0.2,
                            ),
                            _SingleRate(
                              name: 'Status',
                              value: controller.getStatus(keyGenState.status),
                            ),
                          ],
                        ),
                      ),
                      FxContainer.transparent(
                        child: ConditionalSwitch.single<String>(
                          context: context,
                          valueBuilder: (BuildContext context) =>
                              keyGenState.status?.name ?? "",
                          caseBuilders: {
                            KeygenStatus.KEYGEN_COMPLETED.name:
                                (BuildContext context) => FxButton.block(
                                      onPressed: () =>
                                          controller.goToWalletSwitch(),
                                      borderRadiusAll: Constant.buttonRadius.xs,
                                      elevation: 0,
                                      child: FxText.labelLarge(
                                        "Switch to the new wallet",
                                        fontWeight: 700,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                            KeygenStatus.KEYGEN_FAILED.name:
                                (BuildContext context) => FxButton.block(
                                      onPressed: () => controller.goBack(),
                                      borderRadiusAll: Constant.buttonRadius.xs,
                                      elevation: 0,
                                      child: FxText.labelLarge(
                                        "Failed. Go back",
                                        fontWeight: 700,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                          },
                          fallbackBuilder: (BuildContext context) => Column(
                            children: [
                              CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            });
      },
    );
  }
}

class _SingleRate extends StatelessWidget {
  final String name;
  final String value;

  const _SingleRate({Key? key, required this.name, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: FxText.titleMedium(name, fontWeight: 600)),
          FxText.bodyLarge(value, fontWeight: 600),
        ],
      ),
    );
  }
}
