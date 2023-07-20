import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/apps_categories/apps_dex_screen.dart';
import 'package:mobileapp/screens/v1/views/apps_controller.dart';
import 'package:mobileapp/theme/app_theme.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  _AppsScreenState createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  late ThemeData theme;
  late AppsController controller;
  List<String> tabNames = [
    'DEX',
  ];

  _AppsScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = AppsController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AppsController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: FxText.titleLarge("Apps"),
              centerTitle: true,
              elevation: 0,
              actions: const [],
            ),
            body: DefaultTabController(
              length: tabNames.length,
              initialIndex: 0,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 48,
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*-------------- Build Tabs here ------------------*/
                      TabBar(isScrollable: true, tabs: getTabs())
                    ],
                  ),
                ),

                /*--------------- Build Tab body here -------------------*/
                body: TabBarView(children: getTabContents()),
              ),
            ),
          );
        });
  }

  List<Tab> getTabs() {
    List<Tab> tabs = [];

    for (String tabName in tabNames) {
      tabs.add(Tab(
          child: FxText.labelMedium(
        tabName,
        fontWeight: 700,
      )));
    }

    return tabs;
  }

  List<Widget> getTabContents() {
    return [
      const AppsDexScreen(),
    ];
  }
}
