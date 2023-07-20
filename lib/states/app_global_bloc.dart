import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobileapp/blockchainlibs/blockchain_lib.dart';
import 'package:mobileapp/blockchainlibs/tss_lib.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/sse_service.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/signingserver/signing_server.dart';
import 'package:mobileapp/signingserver/signing_service.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/common_bloc.dart';
import 'package:mobileapp/states/key_generation_bloc.dart';
import 'package:mobileapp/states/key_generation_state.dart';
import 'package:mobileapp/states/settings_bloc.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/signing_bloc.dart';
import 'package:mobileapp/states/signing_state.dart';
import 'package:mobileapp/states/user_bloc.dart';
import 'package:mobileapp/states/user_state.dart';
import 'package:mobileapp/states/wallets_bloc.dart';
import 'package:mobileapp/states/wallets_state.dart';

class AppGlobalBloc extends HydratedCubit<AppGlobalState> {
  BuildContext? context;
  final KbusClient kbus;
  final WalletService walletService;
  final SseService sseService;
  final SigningServer signingServer;
  final SigningService signingService;
  final TssLib tssLib;
  final BlockchainLib blockchainLib;

  AppGlobalBloc(this.kbus, this.walletService, this.sseService,
      this.blockchainLib, this.signingServer, this.tssLib, this.signingService)
      : super(AppGlobalState(
            settingsState: SettingsState(isHotWallet: true, whitelisted: false, connected: false),
            keyGenerationState: KeyGenerationState(),
            signingState: SigningState(),
            walletsState: WalletsState(),
            userState: UserState(authForm: "login"))) {
    CommonBloc commonBloc = CommonBloc(() => state, (state) => emit(state),
        (ctx) => context = ctx, () => context, kbus, sseService);
    KeyGenerationBloc(() => state, (state) => emit(state),
        (ctx) => context = ctx, () => context, kbus, walletService, signingServer, tssLib);
    SigningBloc(() => state, (state) => emit(state), (ctx) => context = ctx, () => context,
        kbus, walletService, tssLib, signingService, blockchainLib);
    WalletsBloc(() => state, (state) => emit(state), (ctx) => context = ctx, () => context,
        kbus, walletService, commonBloc, blockchainLib);
    SettingsBloc(
        () => state, (state) => emit(state), (ctx) => context = ctx, () => context, kbus);
    UserBloc(
        () => state, (state) => emit(state), (ctx) => context = ctx, () => context, kbus);
  }

  @override
  AppGlobalState? fromJson(Map<String, dynamic> json) {
    try {
      final state = AppGlobalState.fromJson(json);
      return state;
    } on Exception catch (err) {
      developer.log("error when load state: $err");
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AppGlobalState state) {
    return state.toJson();
  }
}
