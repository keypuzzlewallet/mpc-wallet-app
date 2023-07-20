import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/select_default_wallet.dart';
import 'package:mobileapp/events/enums/keygen_status.dart';
import 'package:mobileapp/events/keygenv2/keygen_progress.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/keygen_sharing.dart';
import 'package:mobileapp/models/presignature_sharing.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/wallet_select_screen.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/sse_service.dart';
import 'package:mobileapp/services/user_service.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/key_generation_mode.dart';
import 'package:mobileapp/states/key_generation_state.dart';

class WaitNewWalletController extends FxController {
  int joinedMembers = 0;
  int progress = 0;
  static Timer? timer;

  WaitNewWalletController();

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
    String? server =
        getIt<AppGlobalBloc>().state.keyGenerationState.serverEndpoint;
    String? roomId = getIt<AppGlobalBloc>().state.keyGenerationState.keygenId;
    if (timer != null && timer!.isActive) timer!.cancel();
    String requestId = getIt<SseService>().requestId;
    getIt<UserService>().getUserToken().then((token) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (roomId != null && server != null) {
          Response response = await http
              .get(Uri.parse("$server/rooms/$roomId/status"), headers: {
            "Accept": "application/json",
            "Cache-Control": "no-cache",
            "X-Request-ID": requestId,
            "X-Token": token!,
          });
          if (response.statusCode == 200) {
            KeygenProgress status =
                KeygenProgress.fromJson(jsonDecode(response.body));
            if (joinedMembers < status.members.length ||
                progress < status.progress) {
              joinedMembers = status.members.length;
              progress = status.progress;
              update();
            }
          }
        }
      });
    });
  }

  @override
  String getTag() {
    return "wait_new_wallet_controller";
  }

  void goBack() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    timer?.cancel();
    getIt<TabController>().animateTo(0);
  }

  copyKeygenId(KeyGenerationState state) async {
    await Clipboard.setData(
        ClipboardData(text: jsonEncode(await getSharingJoinSession(state))));
  }

  goToWalletSwitch() async {
    timer?.cancel();
    Navigator.of(context).popUntil((route) => route.isFirst);
    WalletEntity? wallet = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WalletSelectScreen(title: "Switch Wallet"),
      ),
    );
    if (wallet != null) {
      getIt<KbusClient>().fireE(this, SelectDefaultWallet(wallet));
    }
  }

  Future<Map<String, dynamic>> getSharingJoinSession(
      KeyGenerationState state) async {
    if (state.mode == KeyGenerationMode.KEY_GENERATION) {
      if (state.serverEndpoint != null &&
          state.keygenId != null &&
          state.currentKeygenWalletName != null &&
          state.numberOfMembers != null &&
          state.numberOfRequiredSignatures != null) {
        return KeygenSharing(
                await getAppVersion(),
                state.serverEndpoint!,
                state.keygenId!,
                state.currentKeygenWalletName!,
                state.numberOfMembers!,
                state.numberOfRequiredSignatures!)
            .toJson();
      } else {
        return {};
      }
    } else {
      if (state.serverEndpoint != null &&
          state.walletId != null &&
          state.keygenId != null &&
          state.requestId != null &&
          state.nonceStartIndex != null &&
          state.numberOfNonceToGenerate != null &&
          state.generateNonceKeySchema != null) {
        return PresignatureSharing(
                await getAppVersion(),
                state.serverEndpoint!,
                state.walletId!,
                state.keygenId!,
                state.requestId!,
                state.nonceStartIndex!,
                state.numberOfNonceToGenerate!,
                state.generateNonceKeySchema!)
            .toJson();
      } else {
        return {};
      }
    }
  }

  getStatus(KeygenStatus? status) {
    if (status == KeygenStatus.KEYGEN_SESSION_CREATED) {
      return "Waiting";
    } else if (status == KeygenStatus.KEYGEN_COMPLETED) {
      return "Completed";
    } else if (status == KeygenStatus.KEYGEN_FAILED) {
      return "Error";
    } else {
      return "Unknown";
    }
  }
}
