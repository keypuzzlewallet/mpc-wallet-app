import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/components/rotate_qr_images.dart';
import 'package:mobileapp/events/enums/signing_status.dart';
import 'package:mobileapp/screens/v1/views/wait_signing_controller.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/signing_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class WaitSigningScreen extends StatefulWidget {
  const WaitSigningScreen({
    Key? key,
  }) : super(key: key);

  @override
  _WaitSigningScreenState createState() => _WaitSigningScreenState();
}

class _WaitSigningScreenState extends State<WaitSigningScreen> {
  late ThemeData theme;
  late WaitSigningController controller;

  _WaitSigningScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = WaitSigningController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<WaitSigningController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
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
                  "Transaction Details",
                ),
                actions: const <Widget>[],
              ),
              body: BlocSelector<AppGlobalBloc, AppGlobalState, SigningState>(
                selector: (state) => state.signingState,
                builder: (context, signingState) {
                  return BlocSelector<AppGlobalBloc, AppGlobalState,
                      SettingsState>(
                    selector: (state) {
                      return state.settingsState;
                    },
                    builder: (context, settingsState) {
                      return ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            child: FxContainer(
                              padding: const EdgeInsets.only(
                                  top: 36, bottom: 36, right: 40, left: 40),
                              color: theme.cardTheme.color,
                              borderRadiusAll: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                "Send ${controller.getAmount(signingState.currentSigningRequest)}  ${signingState.currentSigningRequest?.coin.name ?? ""}",
                                            style: FxTextStyle.headlineSmall(
                                                letterSpacing: 0)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      RotateQrImages(
                                        key: ValueKey(signingState
                                                .currentSigningRequest ??
                                            ""),
                                        data: controller.getRequestRqCode(
                                            signingState.currentSigningRequest),
                                        size: 300.0,
                                        length: 150,
                                        duration:
                                            const Duration(milliseconds: 250),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          FxText.bodySmall(
                                            "Copy transaction request",
                                          ),
                                          IconButton(
                                              onPressed: () => controller
                                                  .copyRequestRqCode(signingState
                                                      .currentSigningRequest),
                                              icon: Icon(
                                                AppIcons.copy,
                                                color:
                                                    theme.colorScheme.primary,
                                                size: 18,
                                              ))
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, top: 32, right: 20),
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
                            child: buildDetail(controller, signingState),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: FxText.bodySmall("STATUS", fontWeight: 600),
                          ),
                          FxContainer.bordered(
                            color: Colors.transparent,
                            margin: const EdgeInsets.all(20),
                            borderRadiusAll: 4,
                            child: Column(
                              children: <Widget>[
                                _SingleRate(
                                  name: 'Status',
                                  value: signingState
                                          .currentSigningRequest?.status.name ??
                                      "",
                                  link: signingState.currentSigningRequest
                                                  ?.status ==
                                              SigningStatus
                                                  .SIGNING_BROADCASTED &&
                                          signingState
                                                  .currentSigningRequest
                                                  ?.signingResult
                                                  ?.transactionHash !=
                                              null
                                      ? controller.getExplorerLink(
                                          signingState.currentSigningRequest!
                                              .blockchain,
                                          signingState.currentSigningRequest!
                                              .signingResult!.transactionHash!)
                                      : null,
                                ),
                                signingState.currentSigningRequest?.message !=
                                        null
                                    ? _SingleRate(
                                        name: 'Msg',
                                        value: signingState
                                                .currentSigningRequest
                                                ?.message ??
                                            "",
                                      )
                                    : const SizedBox.shrink(),
                                EnhancedFutureBuilder(
                                    future: controller.signerIdToName(
                                        signingState.currentSigningRequest
                                                ?.pubkey ??
                                            "",
                                        controller.getSignedBy(signingState
                                            .currentSigningRequest
                                            ?.signingResult)),
                                    rememberFutureResult: false,
                                    whenNotDone: const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    ),
                                    whenDone: (data) {
                                      return data.isEmpty
                                          ? const SizedBox.shrink()
                                          : _SingleRate(
                                              name: 'Signed by',
                                              value: data.join(", "),
                                            );
                                    }),
                                EnhancedFutureBuilder(
                                    future: controller.signerIdToName(
                                        signingState.currentSigningRequest
                                                ?.pubkey ??
                                            "",
                                        controller.getRequiredSigners(
                                            signingState
                                                .currentSigningRequest)),
                                    rememberFutureResult: false,
                                    whenNotDone: const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    ),
                                    whenDone: (data) {
                                      return data.isEmpty
                                          ? const SizedBox.shrink()
                                          : _SingleRate(
                                              name: 'Required',
                                              value: data.join(", "),
                                            );
                                    }),
                                const Divider(
                                  thickness: 0.2,
                                ),
                              ],
                            ),
                          ),
                          EnhancedFutureBuilder(
                              future: controller.getSigningWallet(
                                  signingState.currentSigningRequest),
                              rememberFutureResult: false,
                              whenNotDone: const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                              whenDone: (wallet) {
                                if (wallet == null) {
                                  return const SizedBox.shrink();
                                } else if (controller.canInitiateSigning(
                                    wallet,
                                    signingState.currentSigningRequest,
                                    settingsState.isHotWallet)) {
                                  return FxContainer.transparent(
                                    child: FxButton.block(
                                      onPressed: () => controller.initSigning(
                                          signingState.currentSigningRequest),
                                      borderRadiusAll: Constant.buttonRadius.xs,
                                      elevation: 0,
                                      child: FxText.labelLarge(
                                        "Initiate Signing",
                                        fontWeight: 700,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  );
                                } else if (controller.canSign(wallet,
                                    signingState.currentSigningRequest)) {
                                  return FxContainer.transparent(
                                    child: FxButton.block(
                                      onPressed: () => setState(() {
                                        controller.startSigning(
                                            signingState.currentSigningRequest);
                                      }),
                                      borderRadiusAll: Constant.buttonRadius.xs,
                                      elevation: 0,
                                      child: FxText.labelLarge(
                                        "Sign",
                                        fontWeight: 700,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  );
                                } else if (controller.canBroadcast(
                                    wallet,
                                    signingState.currentSigningRequest,
                                    settingsState.isHotWallet)) {
                                  return FxContainer.transparent(
                                    child: FxButton.block(
                                      onPressed: () => controller.broadcast(
                                          signingState.currentSigningRequest),
                                      disabled: !settingsState.isHotWallet,
                                      borderRadiusAll: Constant.buttonRadius.xs,
                                      elevation: 0,
                                      child: FxText.labelMedium(
                                        "Broadcast",
                                        fontWeight: 700,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  );
                                } else if (controller.canHotSigning(
                                    wallet,
                                    signingState.currentSigningRequest,
                                    settingsState.isHotWallet)) {
                                  return FxContainer.transparent(
                                    child: FxButton.block(
                                      onPressed: () => controller.hotSigning(
                                          signingState.currentSigningRequest),
                                      disabled: !settingsState.isHotWallet,
                                      borderRadiusAll: Constant.buttonRadius.xs,
                                      elevation: 0,
                                      child: FxText.labelLarge(
                                        "Hot Signing",
                                        fontWeight: 700,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                        ],
                      );
                    },
                  );
                },
              ));
        });
  }

  Widget buildDetail(
      WaitSigningController controller, SigningState signingState) {
    if (signingState.currentSigningRequest?.sendRequest != null) {
      return buildSendRequest(controller, signingState);
    } else if (signingState.currentSigningRequest?.sendTokenRequest != null) {
      return buildSendTokenRequest(controller, signingState);
    } else if (signingState.currentSigningRequest?.ethSmartContractRequest !=
        null) {
      return buildSmartContractRequest(controller, signingState);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildSendRequest(
      WaitSigningController controller, SigningState signingState) {
    return Column(
      children: <Widget>[
        EnhancedFutureBuilder(
          future: controller.getSignerName(signingState.currentSigningRequest),
          rememberFutureResult: true,
          whenNotDone: const SizedBox.shrink(),
          whenDone: (data) => _SingleRate(name: 'Signer', value: data),
        ),
        _SingleRate(
          name: 'From',
          value: shortAddress(
              signingState.currentSigningRequest?.fromAddress ?? "",
              size: 16),
          copiableText: signingState.currentSigningRequest?.fromAddress,
        ),
        _SingleRate(
          name: 'To',
          value: shortAddress(
              signingState.currentSigningRequest?.sendRequest?.toAddress ?? "",
              size: 16),
          copiableText:
              signingState.currentSigningRequest?.sendRequest?.toAddress,
        ),
        _SingleRate(
            name: 'Blockchain',
            value: signingState.currentSigningRequest?.blockchain.name ?? ""),
        _SingleRate(
            name: 'Amount',
            value:
                "${signingState.currentSigningRequest?.sendRequest?.amount.toString() ?? ""} ${signingState.currentSigningRequest?.coin.name}"),
        _SingleRate(
            name: 'Fee',
            value:
                "${signingState.currentSigningRequest?.fee?.toString() ?? ""} ${signingState.currentSigningRequest?.coin.name}"),
      ],
    );
  }

  Widget buildSendTokenRequest(
      WaitSigningController controller, SigningState signingState) {
    return Column(
      children: <Widget>[
        EnhancedFutureBuilder(
          future: controller.getSignerName(signingState.currentSigningRequest),
          rememberFutureResult: true,
          whenNotDone: const SizedBox.shrink(),
          whenDone: (data) => _SingleRate(name: 'Signer', value: data),
        ),
        _SingleRate(
          name: 'From',
          value: shortAddress(
              signingState.currentSigningRequest?.fromAddress ?? "",
              size: 16),
          copiableText: signingState.currentSigningRequest?.fromAddress,
        ),
        _SingleRate(
          name: 'To',
          value: shortAddress(
              signingState.currentSigningRequest?.sendTokenRequest?.toAddress ??
                  "",
              size: 16),
          copiableText:
              signingState.currentSigningRequest?.sendTokenRequest?.toAddress,
        ),
        _SingleRate(
            name: 'Blockchain',
            value: signingState.currentSigningRequest?.blockchain.name ?? ""),
        _SingleRate(
            name: 'Amount',
            value:
                "${signingState.currentSigningRequest?.sendTokenRequest?.amount.toString() ?? ""} ${signingState.currentSigningRequest?.coin.name}"),
        _SingleRate(
            name: 'Fee',
            value:
                "${signingState.currentSigningRequest?.fee?.toString() ?? ""} ${signingState.currentSigningRequest?.coin.name}"),
      ],
    );
  }

  Widget buildSmartContractRequest(
      WaitSigningController controller, SigningState signingState) {
    return Column(
      children: <Widget>[
        EnhancedFutureBuilder(
          future: controller.getSignerName(signingState.currentSigningRequest),
          rememberFutureResult: true,
          whenNotDone: const SizedBox.shrink(),
          whenDone: (data) => _SingleRate(name: 'Signer', value: data),
        ),
        _SingleRate(
          name: 'From',
          value: shortAddress(
              signingState.currentSigningRequest?.fromAddress ?? "",
              size: 16),
        ),
        _SingleRate(
          name: 'To',
          value: shortAddress(
              signingState.currentSigningRequest?.ethSmartContractRequest
                      ?.toAddress ??
                  "",
              size: 16),
          copiableText: signingState
              .currentSigningRequest?.ethSmartContractRequest?.toAddress,
        ),
        _SingleRate(
            name: 'Blockchain',
            value: signingState.currentSigningRequest?.blockchain.name ?? ""),
        _SingleRate(
            name: 'Amount',
            value:
                "${signingState.currentSigningRequest?.ethSmartContractRequest?.amount.toString() ?? ""} ${signingState.currentSigningRequest?.coin.name}"),
        _SingleRate(
            name: 'Data',
            value: shortAddress(
                signingState
                        .currentSigningRequest?.ethSmartContractRequest?.data ??
                    "",
                size: 20)),
        _SingleRate(
            name: 'Fee',
            value:
                "${signingState.currentSigningRequest?.fee?.toString() ?? ""} ${signingState.currentSigningRequest?.coin.name}"),
      ],
    );
  }
}

class _SingleRate extends StatelessWidget {
  final String name;
  final String value;
  final String? copiableText;
  final String? link;

  const _SingleRate(
      {Key? key,
      required this.name,
      required this.value,
      this.copiableText,
      this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: FxSpacing.bottom(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  name,
                  fontWeight: 600,
                ),
                FxSpacing.height(2),
                FxText.bodySmall(value),
              ],
            ),
          ),
          if (copiableText != null)
            SizedBox(
                height: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    size: 16,
                  ),
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: copiableText)),
                )),
          if (link != null)
            SizedBox(
              height: 16,
              child: IconButton(
                icon: const Icon(
                  AppIcons.openNew,
                  size: 16,
                ),
                onPressed: () => launchUrl(Uri.parse(link!)),
              ),
            ),
        ],
      ),
    );
  }
}
