import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/send_command.dart';
import 'package:mobileapp/actions/submit_join_signing.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/signing_status.dart';
import 'package:mobileapp/events/signing/hot_signing_request.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/signing/signing_result.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_service.dart';

class WaitSigningController extends FxController {
  WaitSigningController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  startSigning(SigningRequest? signingRequest) async {
    if (signingRequest == null) {
      return;
    }
    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(this, SubmitJoinSigning(signingRequest));
    }
  }

  @override
  String getTag() {
    return "wait_signing_controller";
  }

  void goBack() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    getIt<TabController>().animateTo(1);
  }

  int getCurrentNumberOfPartSign(SigningResult? signingResult) {
    if (signingResult?.signingHashes == null) {
      return 0;
    } else {
      if (signingResult?.signingHashes.isEmpty ?? true) {
        return 0;
      }
      return signingResult
              ?.signingHashes[0].state?.signing_parts_base64.length ??
          0;
    }
  }

  Map<String, dynamic> getRequestRqCode(SigningRequest? signingRequest) {
    if (signingRequest == null) {
      return {};
    }
    return jsonDecode(jsonEncode(signingRequest.toJson()));
  }

  copyRequestRqCode(SigningRequest? signingRequest) async {
    if (signingRequest == null) return;
    await Clipboard.setData(
        ClipboardData(text: jsonEncode(getRequestRqCode(signingRequest))));
  }

  List<int> getSignedBy(SigningResult? signingResult) {
    if (signingResult == null) {
      return [];
    }
    if (signingResult.signingHashes.isEmpty) {
      return [];
    }
    return signingResult.signingHashes[0].state?.signing_parts_base64
            .map((e) => e.party_id)
            .toList() ??
        [];
  }

  List<int> getRequiredSigners(SigningRequest? currentSigningRequest) {
    if (currentSigningRequest == null) {
      return [];
    }
    return currentSigningRequest.signers
        .where((signer) =>
            !getSignedBy(currentSigningRequest.signingResult).contains(signer))
        .toList();
  }

  Future<List<String>> signerIdToName(
      String pubkey, List<int> signerIds) async {
    WalletEntity? wallet =
        await getIt<WalletService>().getWalletByPubkey(FirebaseAuth.instance.currentUser?.uid, pubkey);
    if (wallet == null) {
      return [];
    }
    return wallet.members
        .where((member) => signerIds.contains(member.party_id))
        .map((e) => e.party_name)
        .toList();
  }

  bool canSign(WalletEntity wallet, SigningRequest? signingRequest) {
    return signingRequest != null &&
        signingRequest.status == SigningStatus.SIGNING_IN_PROGRESS &&
        getRequiredSigners(signingRequest).contains(wallet.partyId);
  }

  Future<WalletEntity?> getSigningWallet(SigningRequest? signingRequest) async {
    if (signingRequest == null) return null;
    return await getIt<WalletService>()
        .getWalletByPubkey(FirebaseAuth.instance.currentUser?.uid, signingRequest.pubkey);
  }

  Future<String> getSignerName(SigningRequest? signingRequest) async {
    if (signingRequest == null) return "";
    WalletEntity? wallet =
        await getIt<WalletService>().getWalletByPubkey(FirebaseAuth.instance.currentUser?.uid, signingRequest.pubkey);
    if (wallet == null) return "";
    return wallet.members
        .firstWhere((member) => member.party_id == wallet.partyId)
        .party_name;
  }

  initSigning(SigningRequest? currentSigningRequest) async {
    if (currentSigningRequest == null) {
      return;
    }

    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(this, currentSigningRequest);
    }
  }

  broadcast(SigningRequest? currentSigningRequest) async {
    if (currentSigningRequest == null) {
      return;
    }

    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(
          this,
          currentSigningRequest.copyWith(
              status: SigningStatus.SIGNING_COMPLETED,
              version: currentSigningRequest.version + 1));
    }
  }

  bool canInitiateSigning(
      WalletEntity wallet, SigningRequest? signingRequest, bool isHotWallet) {
    return isHotWallet &&
        signingRequest != null &&
        signingRequest.status == SigningStatus.SIGNING_SESSION_CREATED &&
        getRequiredSigners(signingRequest).contains(wallet.partyId);
  }

  bool canBroadcast(
      WalletEntity wallet, SigningRequest? signingRequest, bool isHotWallet) {
    return isHotWallet &&
        signingRequest != null &&
        getRequiredSigners(signingRequest).isEmpty &&
        (signingRequest.status == SigningStatus.SIGNING_COMPLETED ||
            // allow retry on failed
            signingRequest.status == SigningStatus.SIGNING_FAILED);
  }

  bool canHotSigning(
      WalletEntity wallet, SigningRequest? signingRequest, bool isHotWallet) {
    return isHotWallet &&
        signingRequest != null &&
        wallet.isHotSigningWallet == true &&
        signingRequest.status == SigningStatus.SIGNING_IN_PROGRESS &&
        // only the last signing is assigned to server
        (signingRequest.signingResult?.signingHashes[0].state
                    ?.signing_parts_base64.length ??
                -1) ==
            (signingRequest.signingResult?.signingHashes[0].state?.t ?? 0);
  }

  hotSigning(SigningRequest? signingRequest) async {
    if (signingRequest == null) {
      return;
    }
    getIt<KbusClient>().action(
        this,
        HotSigningRequest(
            signingRequest: signingRequest));
  }

  getAmount(SigningRequest? currentSigningRequest) {
    if (currentSigningRequest?.sendRequest != null) {
      return currentSigningRequest?.sendRequest?.amount.toString();
    } else if (currentSigningRequest?.sendTokenRequest != null) {
      return currentSigningRequest?.sendTokenRequest?.amount.toString();
    } else if (currentSigningRequest?.ethSmartContractRequest != null) {
      return currentSigningRequest?.ethSmartContractRequest?.amount.toString();
    } else {
      return "";
    }
  }

  String getExplorerLink(Blockchain b, String transactionHash) {
    return getIt<CurrencyConfig>().blockchainConfigs[b]!.txExplorer.replaceFirst("{txId}", transactionHash);
  }
}
