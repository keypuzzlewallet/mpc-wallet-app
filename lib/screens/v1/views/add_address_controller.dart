import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/update_address_list_item.dart';
import 'package:mobileapp/events/blockchain/config/coin_config.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/address_list_item.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/screens/v1/views/qr_scan_screen.dart';
import 'package:mobileapp/services/kbus.dart';

class AddAddressController extends FxController {
  bool isWhitelisted = false;
  List<CoinConfig> availableCoins = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  AddAddressController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  String getTag() {
    return "address_list_controller";
  }

  setWhiteList(bool? value) {
    isWhitelisted = value ?? false;
  }

  submit(BlockchainCoinItem coinItem) async {
    if (addressController.text.isEmpty) {
      getIt<KbusClient>().action(this,
          Alert(level: AlertLevel.ERROR, message: "Address cannot be empty"));
      return;
    }
    if (addressController.text.isEmpty) {
      getIt<KbusClient>().action(this,
          Alert(level: AlertLevel.ERROR, message: "Address cannot be empty"));
      return;
    }
    if (nameController.text.isEmpty) {
      getIt<KbusClient>().action(this,
          Alert(level: AlertLevel.ERROR, message: "Name cannot be empty"));
      return;
    }

    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(
          this,
          UpdateAddressListItem(AddressListItem(
              nameController.text,
              coinItem.blockchainConfig.blockchain,
              coinItem.coinConfig.coin,
              addressController.text,
              isWhitelisted,
              DateTime.now())));
      Navigator.of(context).pop();
      getIt<KbusClient>().action(this,
          Alert(level: AlertLevel.INFO, message: "Address added successfully"));
    }
  }

  scanQrCode() async {
    addressController.text = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QrScanScreen(),
      ),
    );
  }
}
