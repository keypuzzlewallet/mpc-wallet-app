import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/screens/v1/views/browser_controller.dart';
import 'package:mobileapp/services/defibrowser/defi_browser.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/wallets_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class BrowserScreen extends StatefulWidget {
  final BlockchainConfig blockchain;
  final List<BlockchainConfig> supportedChains;
  final Coin coin;
  final String mainPage;

  const BrowserScreen(
      {Key? key,
      required this.blockchain,
      required this.coin,
      required this.mainPage,
      required this.supportedChains})
      : super(key: key);

  @override
  _BrowserScreenState createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late ThemeData theme;
  late BrowserController controller;

  _BrowserScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller =
        BrowserController(blockchain: widget.blockchain, coin: widget.coin);
    controller.urlController = TextEditingController(text: widget.mainPage);
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<BrowserController>(
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
              title: FxTextField(
                controller: controller.urlController,
                hintText: 'Enter URL',
                maxLines: 1,
                prefixIcon: const Icon(
                  AppIcons.search,
                  size: 20,
                ),
                suffixIcon: InkWell(
                  onTap: () => controller.urlController!.clear(),
                  child: const Icon(
                    AppIcons.close,
                    size: 20,
                  ),
                ),
                onSubmitted: (value) => controller.loadUrl(value),
              ),
              actions: [
                PopupMenuButton(
                  padding: FxSpacing.zero,
                  icon: SvgPicture.asset(
                      'assets/blockchains/${widget.blockchain.blockchain.name.toLowerCase()}.svg',
                      width: 16,
                      height: 16,
                  ),
                  itemBuilder: (BuildContext context) => widget.supportedChains
                      .map((e) => PopupMenuItem(
                            value: e,
                            onTap: () => controller.changeChain(
                                e, widget.supportedChains),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                      'assets/blockchains/${e.blockchain.name.toLowerCase()}.svg',
                                  width: 16,
                                  height: 16,
                                ),
                                FxSpacing.width(8),
                                Text(e.blockchainName)
                              ],
                            ),
                          ))
                      .toList(),
                  color: theme.colorScheme.background,
                )
              ],
            ),
            body: BlocSelector<AppGlobalBloc, AppGlobalState, WalletsState>(
              selector: (state) => state.walletsState,
              builder: (context, walletsState) {
                return BlocSelector<AppGlobalBloc, AppGlobalState,
                    SettingsState>(
                  selector: (state) => state.settingsState,
                  builder: (context, settingsState) {
                    print(controller.blockchain);
                    return DefiBrowser(
                        chainId: controller.blockchain.chainId!,
                        rpcUrl: controller.blockchain.rpc!,
                        walletAddress: walletsState.defaultWallet != null
                            ? controller.getAddress(walletsState.defaultWallet!)
                            : null,
                        signCallback: (rawData, eip1193, cont) =>
                            controller.handleSignCallback(
                                rawData,
                                eip1193,
                                walletsState.defaultWallet,
                                settingsState.whitelisted),
                        onReceivedServerTrustAuthRequest:
                            (controller, challenge) async {
                          // TODO: on prod, we don't do this. for testing only
                          return ServerTrustAuthResponse(
                              action: ServerTrustAuthResponseAction.PROCEED);
                        },
                        onWebViewCreated: (c) {
                          controller.webViewController = c;
                        },
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            useShouldOverrideUrlLoading: true,
                            mediaPlaybackRequiresUserGesture: false,
                          ),
                          android: AndroidInAppWebViewOptions(
                            useHybridComposition: true,
                            domStorageEnabled: true,
                          ),
                          ios: IOSInAppWebViewOptions(
                            allowsInlineMediaPlayback: true,
                          ),
                        ),
                        initialUrlRequest:
                            URLRequest(url: Uri.tryParse(widget.mainPage)));
                  },
                );
              },
            ),
          );
        });
  }
}
