import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/create_wallet_options_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class CreateWalletOptionsScreen extends StatefulWidget {
  const CreateWalletOptionsScreen({Key? key}) : super(key: key);

  @override
  _CreateWalletOptionsScreenState createState() =>
      _CreateWalletOptionsScreenState();
}

class _CreateWalletOptionsScreenState extends State<CreateWalletOptionsScreen> {
  late ThemeData theme;
  late CreateWalletOptionsController controller;
  final List<WalletCreationConfig> walletConfigs = [
    WalletCreationConfig(
        name: "Semi-custodial Trusted Wallet",
        description:
            "KeyPuzzle holds half of your private keys while the other half is stored on your device",
        usecase: "Simple to use but you need to trust KeyPuzzle.",
        isOnline: true,
        image: "assets/images/simple_wallet.jpeg",
        t: 1,
        n: 2),
    WalletCreationConfig(
        name: "Semi-custodial Trustless Wallet",
        description:
            "A private key is created by three fragments. KeyPuzzle holds one fragment of your private keys while the other two fragments are stored on two of your devices.",
        usecase:
            "Simple to use. An additional device is used as a backup in the case you can't access to KeyPuzzle server.",
        isOnline: true,
        image: "assets/images/trusted_wallet.jpeg",
        t: 1,
        n: 3),
    WalletCreationConfig(
        name: "Self-custodial Wallet",
        description:
            "These fragments are distributed on three of your devices. The whole creation process is offline.",
        usecase:
            "The safest way to create and store your private key if you want to self-custody.",
        isOnline: false,
        image: "assets/images/selfcustody_wallet.jpeg",
        t: 1,
        n: 3),
  ];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  _CreateWalletOptionsScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = CreateWalletOptionsController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CreateWalletOptionsController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: FxText.titleLarge("New Wallet"),
              leading: InkWell(
                  onTap: () {
                    controller.goBack();
                  },
                  child: const Icon(AppIcons.back)),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: PageView(
                        pageSnapping: true,
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: walletConfigs
                            .map((w) => _SingleNewsPage(
                                config: w, controller: controller))
                            .toList()),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicatorStatic(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withAlpha(120),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  List<Widget> _buildPageIndicatorStatic() {
    List<Widget> list = [];
    for (int i = 0; i < walletConfigs.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }
}

class _SingleNewsPage extends StatelessWidget {
  final WalletCreationConfig config;
  final CreateWalletOptionsController controller;

  const _SingleNewsPage(
      {Key? key, required this.config, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          Image(
            image: AssetImage(config.image),
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
          FxSpacing.height(20),
          Card(
            elevation: 2,
            margin: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 24, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Icon(
                                AppIcons.members,
                                color: config.isOnline
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.primary,
                                size: 16,
                              ),
                              FxSpacing.width(4),
                              FxText.bodyMedium(
                                config.n.toString(),
                              ),
                              FxSpacing.width(20),
                              Icon(
                                AppIcons.requiredSigners,
                                color: config.isOnline
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.primary,
                                size: 16,
                              ),
                              FxSpacing.width(4),
                              FxText.bodyMedium(
                                (config.t + 1).toString(),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: FxText.titleLarge(
                              config.name,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: FxText.bodyMedium(config.description,
                                fontWeight: 500, height: 1.2),
                          ),
                          FxSpacing.height(10),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            child: FxText.bodyMedium(config.usecase,
                                fontWeight: 500, height: 1.2),
                          ),
                          FxSpacing.height(20),
                          BlocSelector<AppGlobalBloc, AppGlobalState,
                              SettingsState>(
                            selector: (state) => state.settingsState,
                            builder: (context, settingsState) {
                              return Container(
                                child: Center(
                                  child: config.isOnline &&
                                          !settingsState.isHotWallet
                                      ? Container(
                                          padding: const EdgeInsets.all(8),
                                          child: FxText.bodyMedium(
                                              "Switch to Hot wallet in Settings > Security",
                                              fontWeight: 700))
                                      : FxButton.medium(
                                          elevation: 0,
                                          borderRadiusAll: 4,
                                          onPressed: () =>
                                              controller.createWallet(config),
                                          child: FxText.bodyMedium(
                                              "CREATE WALLET".toUpperCase(),
                                              fontWeight: 700,
                                              color:
                                                  theme.colorScheme.onPrimary)),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WalletCreationConfig {
  final String name;
  final String description;
  final String usecase;
  final String image;
  final bool isOnline;
  final int t;
  final int n;

  WalletCreationConfig(
      {required this.name,
      required this.description,
      required this.usecase,
      required this.image,
      required this.isOnline,
      required this.t,
      required this.n});
}
