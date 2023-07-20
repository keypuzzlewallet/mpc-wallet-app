import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/update_hot_wallet.dart';
import 'package:mobileapp/actions/update_whitelisted_addresses.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/services/kbus.dart';

class SecuritySettingsController extends FxController {
  SecuritySettingsController();

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
    return "security_settings_controller";
  }

  updateHotWalletDevice(bool value) async {
    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(this, UpdateHotWallet(value));
    }
  }

  updateWhitelistedAddress(bool value) async {
    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(this, UpdateWhitelistedAddress(value));
    }
  }
}
