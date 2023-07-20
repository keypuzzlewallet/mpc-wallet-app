import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/reload_signing_list.dart';
import 'package:mobileapp/actions/selected_signing_request.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/scan_signing_screen.dart';
import 'package:mobileapp/screens/v1/views/wait_signing_screen.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_service.dart';

class SigningListController extends FxController {
  String searchKeyword = "";

  SigningListController();

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
    return "signing_list_controller";
  }

  signingSelected(SigningRequest session) async {
    WalletEntity? signingWallet = await getIt<WalletService>()
        .getWalletByPubkey(
            FirebaseAuth.instance.currentUser?.uid, session.pubkey);
    if (signingWallet == null) {
      getIt<KbusClient>().fireE(
          this,
          Alert(
              message: "Cannot find wallet for this signing request",
              level: AlertLevel.ERROR));
      return;
    }
    getIt<KbusClient>()
        .action(this, SelectedSigningRequest(session, signingWallet));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WaitSigningScreen(),
      ),
    );
  }

  Future refreshList() async {
    getIt<KbusClient>().action(this, ReloadSigningList());
    await Future.delayed(const Duration(seconds: 1));
  }

  goToJoinSigning() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScanSigningScreen(),
      ),
    );
  }

  searchChanged(String value) {
    searchKeyword = value;
  }

  List<SigningRequest> searchSession(List<SigningRequest> sessions) {
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
}
