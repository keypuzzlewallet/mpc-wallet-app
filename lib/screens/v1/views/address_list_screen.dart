import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/models/address_list_item.dart';
import 'package:mobileapp/screens/v1/views/address_list_controller.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late ThemeData theme;
  late AddressListController controller;

  _AddressListScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = AddressListController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AddressListController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => controller.addAddress(),
              elevation: 2,
              child: const Icon(AppIcons.add),
            ),
            appBar: AppBar(
              title: FxText.titleLarge("Address List"),
              centerTitle: true,
              elevation: 0,
              actions: const [],
            ),
            body: BlocSelector<AppGlobalBloc, AppGlobalState,
                List<AddressListItem>>(
              selector: (state) => state.settingsState.addressList ?? [],
              builder: (context, state) => list2(state),
            ),
          );
        });
  }

  Widget list2(List<AddressListItem> items) {
    return ListView(
      padding: FxSpacing.horizontal(
        24,
      ),
      children: [
        FxTextField(
          onChanged: (value) => setState(() {
            controller.searchChanged(value);
          }),
          textFieldStyle: FxTextFieldStyle.outlined,
          labelText: 'Search Address',
          focusedBorderColor: theme.primaryColor,
          cursorColor: theme.focusColor,
          labelStyle: FxTextStyle.bodySmall(
              color: theme.colorScheme.onBackground, xMuted: true),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: theme.focusColor.withAlpha(40),
          suffixIcon: Icon(
            AppIcons.search,
            color: theme.primaryColor,
            size: 20,
          ),
        ),
        FxSpacing.height(20),
        Column(
          children: _buildList(items),
        ),
      ],
    );
  }

  _buildList(List<AddressListItem> items) {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (AddressListItem item in controller.search(items)) {
      list.add(_buildSingle(item));
    }
    return list;
  }

  void _showBottomSheet(BuildContext context, AddressListItem item) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 24, left: 24, right: 24, bottom: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      item.isWhiteListed
                          ? Column(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () => controller.updateWhitelist(
                                        buildContext, item, false),
                                    icon: Icon(AppIcons.unwhitelisted,
                                        size: 26,
                                        color: theme.colorScheme.secondary)),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  child: FxText(
                                    "Remove Whitelist",
                                    color: theme.colorScheme.secondary,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                IconButton(
                                    onPressed: () => controller.updateWhitelist(
                                        buildContext, item, true),
                                    icon: Icon(AppIcons.whitelisted,
                                        size: 26,
                                        color: theme.colorScheme.primary)),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  child: FxText(
                                    "Add Whitelist",
                                    color: theme.colorScheme.primary,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                      Column(
                        children: <Widget>[
                          IconButton(
                              onPressed: () =>
                                  controller.removeAddress(buildContext, item),
                              icon: Icon(AppIcons.delete,
                                  size: 26, color: theme.colorScheme.error)),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: FxText("Remove the Address",
                                textAlign: TextAlign.center,
                                color: theme.colorScheme.error),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildSingle(AddressListItem item) {
    return FxContainer(
      onTap: () => _showBottomSheet(context, item),
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: 16,
      child: Row(
        children: [
          FxContainer.rounded(
            paddingAll: 0,
            child: SvgPicture.asset(
              "assets/coins/${item.coin.name.toLowerCase()}.svg",
              height: 54,
              width: 54,
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    item.isWhiteListed
                        ? Icon(AppIcons.whitelisted,
                            size: 16, color: theme.colorScheme.primary)
                        : const SizedBox.shrink(),
                    FxSpacing.width(4),
                    FxText.bodyMedium(
                      item.name,
                      fontWeight: 600,
                    )
                  ],
                ),
                FxSpacing.height(4),
                Row(children: [
                  FxText.bodySmall(
                    shortAddress(item.address, size: 6),
                  ),
                ]),
                FxSpacing.height(4),
                Row(children: [
                  FxText.bodySmall(
                    item.blockchain.name,
                  ),
                ]),
              ],
            ),
          ),
          FxSpacing.width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FxText.bodySmall(
                dateFormat(item.createdAt),
                fontSize: 10,
                color: theme.colorScheme.onBackground,
                xMuted: true,
              ),
              FxSpacing.height(16)
            ],
          ),
        ],
      ),
    );
  }
}
