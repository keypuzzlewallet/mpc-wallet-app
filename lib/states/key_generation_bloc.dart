import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobileapp/actions/send_command.dart';
import 'package:mobileapp/actions/submit_join_keygen.dart';
import 'package:mobileapp/actions/submit_new_keygen.dart';
import 'package:mobileapp/actions/submit_new_nonce.dart';
import 'package:mobileapp/blockchainlibs/tss_lib.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/enums/keygen_status.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_with_scheme.dart';
import 'package:mobileapp/events/keygenv2/hot_wallet_generate_nonce_request.dart';
import 'package:mobileapp/events/keygenv2/hot_wallet_keygen_request.dart';
import 'package:mobileapp/events/keygenv2/native_generate_dynamic_nonce_request.dart';
import 'package:mobileapp/events/keygenv2/native_keygen_request.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/app_config.dart';
import 'package:mobileapp/models/keygen_sharing.dart';
import 'package:mobileapp/models/nonce_entity.dart';
import 'package:mobileapp/models/presignature_sharing.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/sse_service.dart';
import 'package:mobileapp/services/user_service.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/signingserver/signing_server.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/key_generation_mode.dart';
import 'package:mobileapp/states/key_generation_state.dart';
import 'package:mobileapp/states/sub_bloc.dart';

class KeyGenerationBloc extends SubBloc {
  final KbusClient kbus;
  final TssLib tssLib;
  final WalletService walletService;
  final SigningServer signingServer;
  final int portNumber = 8888;
  final int numberOfNonces = 100;

  KeyGenerationBloc(
      super.getState,
      super.emit,
      super.setContext,
      super.getContext,
      this.kbus,
      this.walletService,
      this.signingServer,
      this.tssLib) {
    kbus
        .onE<SubmitJoinKeygen>(this)
        .listen((event) => _handleSubmitJoinKeygen(event));
    kbus
        .onE<SubmitNewNonce>(this)
        .listen((event) => _handleSubmitNewNonce(event));
    kbus
        .onE<SubmitNewKeygen>(this)
        .listen((event) => _handleSubmitNewKeygen(event));
  }

  // new keygen from joiners/clients
  Future<void> _handleSubmitJoinKeygen(SubmitJoinKeygen event) async {
    if (isKeygenSharing(event.sharingSession)) {
      await _handleSubmitJoinKeygenMode(event);
    } else {
      await _handleSubmitJoinGenerateNonce(event);
    }
  }

  Future<void> _handleSubmitJoinKeygenMode(SubmitJoinKeygen event) async {
    var token = await getIt<UserService>().getUserToken();
    if (token != null) {
      var keygenSharing =
          KeygenSharing.fromJson(jsonDecode(event.sharingSession));
      var clientVersion = await getAppVersion();
      if (keygenSharing.appVersion != clientVersion) {
        kbus.fireE(
            this,
            Alert(
                message:
                    "The app version of the client and server must be the same. Please update your app to the latest version.",
                level: AlertLevel.ERROR));
        return;
      }
      emit(getState().copyWith(
          keyGenerationState: KeyGenerationState().copyWith(
        mode: KeyGenerationMode.KEY_GENERATION,
        currentKeygenSignerName: event.signerName,
        currentKeygenWalletName: keygenSharing.currentKeygenWalletName,
        keygenId: keygenSharing.keygenId,
        serverEndpoint: keygenSharing.serverEndpoint,
        numberOfRequiredSignatures: keygenSharing.numberOfRequiredSignatures,
        numberOfMembers: keygenSharing.numberOfMembers,
        status: KeygenStatus.KEYGEN_SESSION_CREATED,
      )));
      await startKeygen(
          keygenSharing.serverEndpoint,
          keygenSharing.keygenId,
          keygenSharing.currentKeygenWalletName,
          event.signerName,
          keygenSharing.numberOfRequiredSignatures - 1,
          keygenSharing.numberOfMembers,
          false,
          token);
      kbus.fireE(this,
          Alert(level: AlertLevel.INFO, message: "joined key generation"));
    } else {
      kbus.fireE(
          this,
          Alert(
              message:
                  "You must be logged in to join a key generation session.",
              level: AlertLevel.ERROR));
    }
  }

  // new keygen from host
  Future<void> _handleSubmitNewKeygen(SubmitNewKeygen event) async {
    var token = await getIt<UserService>().getUserToken();
    if (token != null) {
      signingServer.stop();
      if (event.isHotSigningWallet && !getState().settingsState.isHotWallet) {
        kbus.fireE(
            this,
            Alert(
                message:
                    "You cannot create a hot signing wallet if you are not a hot wallet.",
                level: AlertLevel.ERROR));
        return;
      }
      // this is the actual server to connect to
      var serverEndpoint = event.isHotSigningWallet
          ? getIt<AppConfig>().keygenEndpoint
          : "http://${await signingServer.start(portNumber)}:$portNumber";
      var keygenId = generateId("KG");
      emit(getState().copyWith(
          keyGenerationState: KeyGenerationState().copyWith(
        mode: KeyGenerationMode.KEY_GENERATION,
        currentKeygenSignerName: event.signerName,
        currentKeygenWalletName: event.walletName,
        numberOfMembers: event.numberOfMembers,
        numberOfRequiredSignatures: event.numberOfRequiredSignatures,
        serverEndpoint: serverEndpoint,
        keygenId: keygenId,
        status: KeygenStatus.KEYGEN_SESSION_CREATED,
      )));
      await startKeygen(
          serverEndpoint,
          keygenId,
          event.walletName,
          event.signerName,
          event.numberOfRequiredSignatures - 1,
          event.numberOfMembers,
          event.isHotSigningWallet,
          token);
    } else {
      kbus.fireE(
          this,
          Alert(
              message:
                  "You must be logged in to create a key generation session.",
              level: AlertLevel.ERROR));
    }
  }

  Future<void> startKeygen(
      String serverAddress,
      String keygenId,
      String walletName,
      String signerName,
      int t,
      int n,
      bool isHotSigningWallet,
      String token) async {
    if (isHotSigningWallet) {
      kbus.fireE(
          this,
          SendCommand(
              command: HotWalletKeygenRequest(
                  keygenId: keygenId,
                  walletName: walletName,
                  numberOfMembers: n,
                  threshold: t,
                  roomId: keygenId,
                  walletCreationConfig: WalletCreationConfig(
                      pubkeys: const [],
                      isMainnet: getIt<AppConfig>().isMainnet,
                      isSegwit: getIt<AppConfig>().isSegwit))));
    }
    try {
      EncryptedKeygenResult keygenResult = await tssLib.keygen(
          NativeKeygenRequest(
              requestId: getIt<SseService>().requestId,
              port: 0,
              address: serverAddress,
              room: keygenId,
              t: t,
              n: n,
              signerName: signerName,
              password:
                  await getIt<WalletService>().createEncryptionKey(keygenId),
              token: token));
      var walletCreationConfig = WalletCreationConfig(
          pubkeys: keygenResult.encryptedKeygenWithScheme
              .map((e) => WalletCreationConfigPubkey(
                  keyScheme: e.keyScheme, pubkey: e.encryptedLocalKey.pubkey))
              .toList(),
          isMainnet: getIt<AppConfig>().isMainnet,
          isSegwit: getIt<AppConfig>().isSegwit);
      await _verifyAndSaveWallet(walletName, signerName, keygenId, t, n,
          keygenResult, walletCreationConfig, isHotSigningWallet);
      signingServer.stop();
    } catch (err, stacktrace) {
      print(stacktrace);
      emit(getState().copyWith(
          keyGenerationState: getState()
              .keyGenerationState
              .copyWith(status: KeygenStatus.KEYGEN_COMPLETED)));
      kbus.fireE(this, Alert(level: AlertLevel.ERROR, message: err.toString()));
      signingServer.stop();
    }
  }

  Future<void> _verifyAndSaveWallet(
      String walletName,
      String signerName,
      String keygenId,
      int t,
      int n,
      EncryptedKeygenResult keygenResult,
      WalletCreationConfig walletCreationConfig,
      bool isHotSigningWallet) async {
    await walletService.storeWallet(
        keygenId,
        keygenResult.encryptedKeygenWithScheme
            .map((e) => WalletCreationConfigPubkey(
                keyScheme: e.keyScheme, pubkey: e.encryptedLocalKey.pubkey))
            .toList(),
        t,
        n,
        keygenResult,
        walletName,
        signerName,
        keygenResult.party_id,
        keygenResult.members,
        FirebaseAuth.instance.currentUser?.uid,
        walletCreationConfig,
        isHotSigningWallet);
    emit(getState().copyWith(
        keyGenerationState: getState()
            .keyGenerationState
            .copyWith(status: KeygenStatus.KEYGEN_COMPLETED)));
    kbus.fireE(
        this,
        Alert(
            level: AlertLevel.INFO,
            message:
                "Wallet ${getState().keyGenerationState.currentKeygenWalletName} created"));
  }

  _handleSubmitNewNonce(SubmitNewNonce event) async {
    String requestId = getIt<SseService>().requestId;
    String roomId = generateId("GN");
    String address = getIt<AppConfig>().keygenEndpoint;

    var privateKey = event
        .wallet.encryptedKeygenResult.encryptedKeygenWithScheme
        .where((element) => element.keyScheme == event.keyScheme)
        .first;

    NonceEntity? nonce = await getIt<WalletService>()
        .getNonce(privateKey.encryptedLocalKey.pubkey, event.keyScheme);

    if (nonce == null) {
      kbus.fireE(
          this,
          Alert(
              message:
                  "You must generate a key before you can generate a nonce",
              level: AlertLevel.ERROR));
      return;
    }
    var nonceStartIndex = nonce.nonceStart + nonce.nonceSize;
    kbus.fireE(
        this,
        SendCommand(
            command: HotWalletGenerateNonceRequest(
                pubkey: privateKey.encryptedLocalKey.pubkey,
                roomId: roomId,
                keyScheme: event.keyScheme,
                nonceSize: numberOfNonces,
                nonceStart: nonceStartIndex)));
    await startGenerateNonce(event.wallet, roomId, address, requestId,
        nonceStartIndex, numberOfNonces, event.keyScheme);
  }

  Future<void> startGenerateNonce(
      WalletEntity wallet,
      String roomId,
      String address,
      String requestId,
      int nonceStartIndex,
      int numberOfNonces,
      KeyScheme keyScheme) async {
    String? token = await getIt<UserService>().getUserToken();
    if (token == null) {
      kbus.fireE(
          this,
          Alert(
              message:
                  "You must be logged in to start nonce generation session",
              level: AlertLevel.ERROR));
      return;
    }

    var privateKey = wallet.encryptedKeygenResult.encryptedKeygenWithScheme
        .where((element) => element.keyScheme == keyScheme)
        .first;

    emit(getState().copyWith(
        keyGenerationState: KeyGenerationState().copyWith(
      mode: KeyGenerationMode.GENERATE_NONCE,
      currentKeygenSignerName: wallet.signerName,
      currentKeygenWalletName: wallet.name,
      keygenId: roomId,
      serverEndpoint: address,
      numberOfRequiredSignatures: wallet.threshold + 1,
      numberOfMembers: wallet.noMembers,
      status: KeygenStatus.KEYGEN_SESSION_CREATED,
      generateNonceKeySchema: keyScheme,
      numberOfNonceToGenerate: numberOfNonces,
      walletId: wallet.walletId,
      nonceStartIndex: nonceStartIndex,
      requestId: requestId,
    )));
    try {
      EncryptedKeygenWithScheme encryptedKey = await tssLib.generateNonce(
          NativeGenerateDynamicNonceRequest(
              port: 0,
              address: address,
              room: roomId,
              requestId: requestId,
              token: token,
              password: await getIt<WalletService>()
                  .getEncryptionKey(wallet.walletId),
              nonceStartIndex: nonceStartIndex,
              nonceSize: numberOfNonces,
              keyScheme: keyScheme,
              encryptedLocalKey: privateKey.encryptedLocalKey));
      await getIt<WalletService>().updateWalletNonce(wallet, encryptedKey);

      emit(getState().copyWith(
          keyGenerationState: getState()
              .keyGenerationState
              .copyWith(status: KeygenStatus.KEYGEN_COMPLETED)));
      kbus.fireE(
          this,
          Alert(
              level: AlertLevel.INFO,
              message: "Generating pre-signatures is completed"));
    } catch (err, stacktrace) {
      print(stacktrace);
      kbus.fireE(this, Alert(level: AlertLevel.ERROR, message: err.toString()));
    }
  }

  _handleSubmitJoinGenerateNonce(SubmitJoinKeygen event) async {
    var keygenSharing =
        PresignatureSharing.fromJson(jsonDecode(event.sharingSession));
    var clientVersion = await getAppVersion();
    if (keygenSharing.appVersion != clientVersion) {
      kbus.fireE(
          this,
          Alert(
              message:
                  "The app version of the client and server must be the same. Please update your app to the latest version.",
              level: AlertLevel.ERROR));
      return;
    }

    WalletEntity? wallet =
        await getIt<WalletService>().getWalletById(keygenSharing.walletId);
    if (wallet == null) {
      kbus.fireE(
          this,
          Alert(
              message:
                  "You must generate a key before you can generate a nonce",
              level: AlertLevel.ERROR));
      return;
    }

    await startGenerateNonce(
        wallet,
        keygenSharing.roomId,
        keygenSharing.address,
        keygenSharing.requestId,
        keygenSharing.nonceStartIndex,
        keygenSharing.nonceSize,
        keygenSharing.keyScheme);
  }

  bool isKeygenSharing(String sharingSession) {
    try {
      KeygenSharing.fromJson(jsonDecode(sharingSession));
      return true;
    } catch (err, stacktrace) {
      print(stacktrace);
      return false;
    }
  }
}
