import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileapp/actions/clear_estimated_fee.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/reload_signing_list.dart';
import 'package:mobileapp/actions/reload_wallet.dart';
import 'package:mobileapp/actions/selected_signing_request.dart';
import 'package:mobileapp/actions/send_command.dart';
import 'package:mobileapp/actions/submit_join_signing.dart';
import 'package:mobileapp/actions/update_hot_wallet.dart';
import 'package:mobileapp/blockchainlibs/blockchain_lib.dart';
import 'package:mobileapp/blockchainlibs/tss_lib.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_request.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_result.dart';
import 'package:mobileapp/events/blockchain/message/verify_transaction_request.dart';
import 'package:mobileapp/events/blockchain/message/verify_transaction_result.dart';
import 'package:mobileapp/events/emailservice/email_action_request.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/enums/signing_status.dart';
import 'package:mobileapp/events/signing/get_signing_list_request.dart';
import 'package:mobileapp/events/signing/get_signing_list_result.dart';
import 'package:mobileapp/events/signing/hot_signing_request.dart';
import 'package:mobileapp/events/signing/native_signing_request.dart';
import 'package:mobileapp/events/signing/signing_hash.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/signing/signing_result.dart';
import 'package:mobileapp/events/signing/signing_state_base64.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/signingserver/signing_service.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/signing_state.dart';
import 'package:mobileapp/states/sub_bloc.dart';
import 'package:mobileapp/states/user_state.dart';

class SigningBloc extends SubBloc {
  final KbusClient kbus;
  final WalletService walletService;
  final SigningService signingService;
  final TssLib tssLib;
  final BlockchainLib blockchainLib;

  SigningBloc(
      super.getState,
      super.emit,
      super.setContext,
      super.getContext,
      this.kbus,
      this.walletService,
      this.tssLib,
      this.signingService,
      this.blockchainLib) {
    kbus
        .onE<UpdateHotWallet>(this)
        .listen((event) => _handleUpdateHotWallet(event));
    kbus.onE<ReloadWallet>(this).listen((event) => _handleReloadWallets(event));
    kbus
        .onE<SigningRequest>(this)
        .listen((event) => _handleNewSigningRequest(event));
    kbus.onE<SubmitJoinSigning>(this).listen((event) => _handleSigning(event));
    kbus
        .onE<SelectedSigningRequest>(this)
        .listen((event) => _handleSelectedSigningRequest(event));
    kbus
        .onE<ControllerLoaded>(this)
        .listen((event) => _handleControllerFetchData(event));
    kbus
        .onE<ReloadSigningList>(this)
        .listen((event) => _handleReloadSigningList(event));
    kbus
        .onE<GetSigningListResult>(this)
        .listen((event) => _handleGetSigningListResult(event));
    kbus
        .onE<EstimateFeeResult>(this)
        .listen((event) => _handleEstimateFeeResult(event));
    kbus
        .onE<ClearEstimatedFee>(this)
        .listen((event) => _handleClearEstimatedFee());
    kbus
        .onE<EstimateFeeRequest>(this)
        .listen((event) => _handleEstimateFeeRequest(event));
    kbus
        .onE<HotSigningRequest>(this)
        .listen((event) => _handleHotSigningRequest(event));
  }

  _handleSigning(SubmitJoinSigning event) async {
    // we check if raw tx matched details that is showing on the screen e.g. recipient, amount, fee
    // we also check to make sure fee amount if not higher than send amount if possible
    if (event.signingRequest.signingResult != null) {
      try {
        VerifyTransactionResult verify = blockchainLib.verify(
            VerifyTransactionRequest(
                blockchain: event.signingRequest.blockchain,
                coin: event.signingRequest.coin,
                rawTransaction:
                    event.signingRequest.signingResult!.unsignedTransaction,
                signingRequest: event.signingRequest));
        if (verify.failedReason != null) {
          kbus.fireE(this,
              Alert(level: AlertLevel.ERROR, message: verify.failedReason!));
          return;
        }
      } catch (e, stacktrace) {
        print(stacktrace);
        kbus.fireE(this, Alert(level: AlertLevel.ERROR, message: e.toString()));
        return;
      }
    }
    WalletEntity? wallet = await walletService.getWalletByPubkey(
        FirebaseAuth.instance.currentUser?.uid, event.signingRequest.pubkey);
    if (wallet == null) {
      kbus.fireE(
          this, Alert(level: AlertLevel.ERROR, message: "Wallet not found"));
      return;
    }
    var updatedSigningHashes = await Future.wait(event
        .signingRequest.signingResult!.signingHashes
        .map((signingHash) async {
      SigningStateBase64 signingState = signingHash.state == null
          ? SigningStateBase64(
              t: wallet.threshold,
              n: wallet.noMembers,
              keyScheme: event.signingRequest.keyScheme,
              signing_parts_base64: const [],
              signature: null)
          : signingHash.state!;
      SigningStateBase64 updatedState = tssLib.sign(NativeSigningRequest(
          stateBase64: signingState,
          hexData: signingHash.hash,
          encryptedLocalKey: wallet
              .encryptedKeygenResult.encryptedKeygenWithScheme
              .firstWhere((element) =>
                  element.keyScheme == event.signingRequest.keyScheme)
              .encryptedLocalKey,
          keyScheme: event.signingRequest.keyScheme,
          partyId: wallet.partyId,
          signers: event.signingRequest.signers,
          nonce: signingHash.nonce,
          password:
              await getIt<WalletService>().getEncryptionKey(wallet.walletId)));
      return signingHash.copyWith(state: updatedState);
    }));
    getIt<WalletService>().updateWalletNonceIndex(
        event.signingRequest.pubkey,
        event.signingRequest.keyScheme,
        event.signingRequest.signingResult!.signingHashes
            .map((e) => e.nonce)
            .reduce(max));
    final updatedSigningRequest = event.signingRequest.copyWith(
        version: event.signingRequest.version + 1,
        status: _isSigningCompleted(updatedSigningHashes, wallet.threshold)
            ? SigningStatus.SIGNING_COMPLETED
            : SigningStatus.SIGNING_IN_PROGRESS,
        signingResult: event.signingRequest.signingResult!
            .copyWith(signingHashes: updatedSigningHashes));
    await signingService.updateSigningRequest(
        FirebaseAuth.instance.currentUser?.uid, updatedSigningRequest);
    if (getState().settingsState.isHotWallet) {
      kbus.fireE(this, SendCommand(command: updatedSigningRequest));
    }
    emit(getState().copyWith(
        signingState: getState().signingState.copyWith(
            currentSigningRequest: updatedSigningRequest,
            signingSessions: await signingService
                .findAll(FirebaseAuth.instance.currentUser?.uid))));
  }

  Future<void> _handleNewSigningRequest(SigningRequest event) async {
    if (getState().walletsState.coins == null) {
      kbus.fireE(
          this, Alert(level: AlertLevel.ERROR, message: "Invalid address"));
    } else {
      if (getState().settingsState.isHotWallet) {
        kbus.fireE(this, SendCommand(command: event));
      }
      await signingService.updateSigningRequest(
          FirebaseAuth.instance.currentUser?.uid, event);
      emit(getState().copyWith(
          signingState: getState().signingState.copyWith(
              currentSigningRequest: event,
              signingSessions: await signingService
                  .findAll(FirebaseAuth.instance.currentUser?.uid))));

      Alert(level: AlertLevel.INFO, message: "Signing request created");
    }
  }

  _handleSelectedSigningRequest(SelectedSigningRequest event) {
    emit(getState().copyWith(
        signingState: getState()
            .signingState
            .copyWith(currentSigningRequest: event.session)));
  }

  _handleReloadWallets(ReloadWallet event) async {
    emit(getState().copyWith(
        signingState: getState().signingState.copyWith(
            signingSessions: await signingService
                .findAll(FirebaseAuth.instance.currentUser?.uid))));
  }

  bool _isSigningCompleted(List<SigningHash> signingHashes, int threshold) {
    // check if all signing parts size are greater than threshold, it means all members have signed
    if (signingHashes.isEmpty) {
      return false;
    }
    final hashSizes =
        signingHashes.map((e) => e.state?.signing_parts_base64.length ?? 0);
    for (var i = 0; i < hashSizes.length; i++) {
      if (hashSizes.elementAt(i) <= threshold) {
        return false;
      }
    }
    return true;
  }

  _handleUpdateHotWallet(UpdateHotWallet event) {
    emit(getState().copyWith(
        settingsState:
            getState().settingsState.copyWith(isHotWallet: event.hotWallet)));
  }

  _handleControllerFetchData(ControllerLoaded event) {
    if (event.controllerTag == "signing_list_controller" &&
        getState().walletsState.defaultWallet != null) {
      kbus.fireE(
          this,
          SendCommand(
              command: GetSigningListRequest(
                  walletId: getState().walletsState.defaultWallet!.walletId)));
    }
  }

  _handleReloadSigningList(ReloadSigningList event) {
    if (getState().walletsState.defaultWallet != null) {
      kbus.fireE(
          this,
          SendCommand(
              command: GetSigningListRequest(
                  walletId: getState().walletsState.defaultWallet!.walletId)));
    }
  }

  _handleGetSigningListResult(GetSigningListResult event) async {
    for (var signing in event.signings) {
      Iterable<SigningRequest> existingSigning =
          (getState().signingState.signingSessions ?? [])
              .where((element) => element.id == signing.id);
      if (existingSigning.isEmpty ||
          existingSigning.first.version < signing.version) {
        await signingService.updateSigningRequest(
            FirebaseAuth.instance.currentUser?.uid, signing);
      }
    }
    emit(getState().copyWith(
        signingState: getState().signingState.copyWith(
            signingSessions: await signingService
                .findAll(FirebaseAuth.instance.currentUser?.uid))));
  }

  _handleEstimateFeeResult(EstimateFeeResult event) {
    emit(getState().copyWith(
        signingState: getState().signingState.copyWith(estimatedFee: event)));
  }

  _handleClearEstimatedFee() {
    emit(getState().copyWith(
        signingState: getState().signingState.copyWith(estimatedFee: null)));
  }

  _handleEstimateFeeRequest(EstimateFeeRequest event) {
    kbus.fireE(this, SendCommand(command: event));
  }

  _handleHotSigningRequest(HotSigningRequest event) {
    if (FirebaseAuth.instance.currentUser != null) {
      kbus.fireE(
          this,
          SendCommand(
              command: EmailActionRequest(
                  command: HotSigningRequest.name(),
                  commandBody: jsonEncode(event))));
    } else {
      emit(getState().copyWith(
          userState: getState()
              .userState
              .copyWith(loginEmail: null, authForm: 'login')));
      kbus.fireE(
          this, Alert(level: AlertLevel.ERROR, message: "Please login first"));
    }
  }
}
