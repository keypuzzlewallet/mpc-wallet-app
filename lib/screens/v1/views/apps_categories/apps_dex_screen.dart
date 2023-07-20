import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/screens/v1/views/apps_categories/apps_dex_controller.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class AppsDexScreen extends StatefulWidget {
  const AppsDexScreen({Key? key}) : super(key: key);

  @override
  _AppsDexScreenState createState() => _AppsDexScreenState();
}

class _AppsDexScreenState extends State<AppsDexScreen> {
  late ThemeData theme;
  late AppsDexController controller;
  List<String> tabNames = [
    'DEX',
  ];

  _AppsDexScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = AppsDexController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AppsDexController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
              body: ListView(
            padding: FxSpacing.x(16),
            children: <Widget>[
              Container(
                  margin: FxSpacing.top(24),
                  child: _ProductListWidget(
                    name: "Uniswap",
                    image: "assets/images/apps/uniswap.svg",
                    blockchains: getIt<CurrencyConfig>().blockchainConfigs.values.where((e) => e.flags.contains("DEFI")).toList(),
                    link: "https://app.uniswap.org/#/swap",
                    controller: controller,
                    buildContext: context,
                  )),
            ],
          ));
        });
  }
}

class _ProductListWidget extends StatefulWidget {
  final String name, image, link;
  final List<BlockchainConfig> blockchains;
  final BuildContext buildContext;
  final AppsDexController controller;

  const _ProductListWidget(
      {Key? key,
      required this.name,
      required this.image,
      required this.blockchains,
      required this.buildContext,
      required this.link,
      required this.controller})
      : super(key: key);

  @override
  __ProductListWidgetState createState() => __ProductListWidgetState();
}

class __ProductListWidgetState extends State<_ProductListWidget> {
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return FxCard(
      shadow: FxShadow(elevation: 8),
      onTap: () {
        var appBlockchain = widget.blockchains[0];
        widget.controller.openApp(appBlockchain,
            getIt<CurrencyConfig>().findCoinInBlockchain(appBlockchain.blockchain).firstWhere((element) => element.isNative).coin, widget.link, widget.blockchains);
      },
      child: Row(
        children: <Widget>[
          Hero(
            tag: const Uuid().v4(),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: SvgPicture.asset(
                widget.image,
                height: 90.0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          FxSpacing.width(20),
          Expanded(
            child: Container(
              height: 90,
              margin: FxSpacing.left(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FxText.titleMedium(widget.name,
                          fontWeight: 700, letterSpacing: 0),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: widget.blockchains
                            .map((e) => SvgPicture.asset(
                          "assets/blockchains/${e.blockchain.name.toLowerCase()}.svg",
                                height: 32,
                                width: 32,
                                ))
                            .toList(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
