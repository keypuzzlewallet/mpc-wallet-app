import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/submit_join_keygen.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/screens/v1/views/qr_scan_screen.dart';
import 'package:mobileapp/screens/v1/views/wait_new_wallet_screen.dart';
import 'package:mobileapp/services/kbus.dart';

class JoinNewWalletController extends FxController {
  String? nickName = null;
  String? keygenSharingJson = null;
  TextEditingController sessionDetailsController = TextEditingController();

  JoinNewWalletController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "join_new_wallet_controller";
  }

  submit() {
    getIt<KbusClient>()
        .action(this, SubmitJoinKeygen(keygenSharingJson!, nickName!));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WaitNewWalletScreen(),
      ),
    );
  }

  void goBack() {
    Navigator.pop(context);
  }

  updateNickName(String value) {
    nickName = value;
  }

  updateKeygenSharingJson(String value) {
    keygenSharingJson = value;
  }

  scan() async {
    sessionDetailsController.text =
        await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QrScanScreen(),
      ),
    );
  }
}
