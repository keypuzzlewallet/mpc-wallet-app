import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/delete_address_list_item.dart';
import 'package:mobileapp/actions/update_address_list_item.dart';
import 'package:mobileapp/events/blockchain/config/coin_config.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/address_list_item.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/screens/v1/views/add_address_screen.dart';
import 'package:mobileapp/screens/v1/views/coin_select_screen.dart';
import 'package:mobileapp/services/kbus.dart';

class AddressListController extends FxController {
  String searchKeyword = "";
  String name = "";
  bool isWhitelisted = false;
  List<CoinConfig> availableCoins = [];

  AddressListController();

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

  searchChanged(String value) {
    searchKeyword = value;
  }

  List<AddressListItem> search(List<AddressListItem> sessions) {
    if (searchKeyword.isEmpty) {
      return sessions;
    }
    return sessions
        .where((element) => element
            .toString()
            .toLowerCase()
            .contains(searchKeyword.toLowerCase()))
        .toList();
  }

  removeAddress(BuildContext buildContext, AddressListItem item) async {
    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(this, DeleteAddressListItem(item));
      Navigator.of(buildContext).pop();
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.INFO, message: "Address removed successfully"));
    }
  }

  updateWhitelist(BuildContext buildContext, AddressListItem item,
      bool isWhitelisted) async {
    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(
          this,
          UpdateAddressListItem(AddressListItem(item.name, item.blockchain,
              item.coin, item.address, isWhitelisted, item.createdAt)));
      Navigator.of(buildContext).pop();
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.INFO, message: "Address updated successfully"));
    }
  }

  addAddress() async {
    BlockchainCoinItem? coinItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CoinSelectScreen(onlyEnabledCoin: true),
      ),
    );
    if (coinItem != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddAddressScreen(coinItem: coinItem),
        ),
      );
    }
  }
}
