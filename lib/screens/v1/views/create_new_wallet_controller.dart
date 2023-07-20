import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/submit_new_keygen.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/screens/v1/views/wait_new_wallet_screen.dart';
import 'package:mobileapp/services/kbus.dart';

class CreateNewWalletController extends FxController {
  String? walletName;
  String? nickName;

  CreateNewWalletController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "create_new_wallet_controller";
  }

  submit(int numberOfRequiredSignatures, int numberOfMembers, bool isHotSigningWallet) async {
    String? errorMsg;

    if ((numberOfMembers) <= 1) {
      errorMsg = "Minimum 2 members is required";
    } else if ((numberOfMembers) > 5) {
      errorMsg = "At the moment we only support maximum 5 members";
    } else if (numberOfRequiredSignatures > numberOfMembers) {
      errorMsg =
          "Required signers must be less than or equal number of members";
    } else if (numberOfRequiredSignatures <= 1) {
      errorMsg = "At least two signers is required";
    }
    if (errorMsg != null) {
      getIt<KbusClient>()
          .fireE(this, Alert(level: AlertLevel.ERROR, message: errorMsg));
    } else {
      getIt<KbusClient>().action(
          this,
          SubmitNewKeygen(numberOfMembers, numberOfRequiredSignatures,
              walletName!, nickName!, isHotSigningWallet));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const WaitNewWalletScreen(),
        ),
      );
    }
  }

  void goBack() {
    Navigator.pop(context);
  }

  updateWalletName(String value) {
    walletName = value;
  }

  updateNickName(String value) {
    nickName = value;
  }
}
