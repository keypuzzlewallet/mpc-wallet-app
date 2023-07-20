import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/screens/v1/views/add_address_controller.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class AddAddressScreen extends StatefulWidget {
  final BlockchainCoinItem coinItem;

  const AddAddressScreen({Key? key, required this.coinItem}) : super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late ThemeData theme;
  late AddAddressController controller;

  _AddAddressScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = AddAddressController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AddAddressController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: FxText.titleLarge("Add Address"),
              centerTitle: true,
              elevation: 0,
              actions: const [],
            ),
            body: Padding(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context), 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FxSpacing.width(20),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              FxTextField(
                                controller: controller.nameController,
                                labelText: "Name",
                                autofocus: true,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FxSpacing.width(5),
                        Checkbox(
                          value: controller.isWhitelisted,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (bool? value) => setState(() =>
                              setState(() => controller.setWhiteList(value))),
                        ),
                        FxText.titleSmall("Is Whitelisting?",
                            color: theme.colorScheme.onBackground)
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FxSpacing.width(20),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              FxTextField(
                                labelText: "Address",
                                controller: controller.addressController,
                                autofocus: true,
                                suffixIcon: IconButton(
                                  icon: const Icon(AppIcons.qrScanner),
                                  onPressed: () => controller.scanQrCode(),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        margin: FxSpacing.top(16),
                        child: FxButton.medium(
                          onPressed: () => controller.submit(widget.coinItem),
                          elevation: 0,
                          borderRadiusAll: Constant.containerRadius.xs,
                          child: FxText.labelMedium("Add Address".toUpperCase(),
                              color: theme.colorScheme.onPrimary,
                              letterSpacing: 0.4),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
