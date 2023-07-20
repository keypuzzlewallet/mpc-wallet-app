import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobileapp/actions/forget_password.dart';
import 'package:mobileapp/actions/login.dart';
import 'package:mobileapp/actions/register.dart';
import 'package:mobileapp/actions/send_logout.dart';
import 'package:mobileapp/actions/switch_auth_form.dart';
import 'package:mobileapp/actions/update_hot_wallet.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/firebase_options.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/app_config.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/user_service.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/signing_state.dart';
import 'package:mobileapp/states/sub_bloc.dart';
import 'package:mobileapp/states/user_state.dart';
import 'package:mobileapp/states/wallets_state.dart';

class UserBloc extends SubBloc {
  final KbusClient kbus;
  bool initializeApp = false;
  Timer? userCheckTimer;

  UserBloc(super.getState, super.emit, super.setContext, super.getContext,
      this.kbus) {
    kbus
        .onE<UpdateHotWallet>(this)
        .listen((event) => _handleUpdateHotWallet(event));
    kbus.onE<Login>(this).listen((event) => _handleLogin(event));
    kbus.onE<Register>(this).listen((event) => _handleRegister(event));
    kbus.onE<SendLogout>(this).listen((event) => _handleSendLogout(event));
    kbus
        .onE<ForgetPassword>(this)
        .listen((event) => _handleForgetPassword(event));
    kbus
        .onE<SwitchAuthForm>(this)
        .listen((event) => _handleSwitchAuthForm(event));
  }

  _handleUpdateHotWallet(UpdateHotWallet event) async {
    if (event.hotWallet && !initializeApp) {
      initializeApp = true;
      print("initializing firebase...");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseAuth.instance
          .userChanges()
          .listen((User? user) => handleUserChanged(user));

      if (getIt<AppConfig>().firebaseTestEndpoint != null) {
        print(
            "using firebase emulator at ${getIt<AppConfig>().firebaseTestEndpoint}:9099");
        await FirebaseAuth.instance
            .useAuthEmulator(getIt<AppConfig>().firebaseTestEndpoint!, 9099);
      }

      FirebaseAuth.instance.currentUser?.reload();
    }
  }

  void handleUserChanged(User? user) {
    print("auth state changed");
    if (user != null && user.emailVerified) {
      print('User is currently: ${user.email}');
      userCheckTimer?.cancel();
      // reset state new login
      if ((user.uid ?? "") !=
          (getState().walletsState.defaultWallet?.owner ?? "")) {
        print("resetting wallet state due to logging in different user");
        emit(getState().copyWith(
          userState: getState().userState.copyWith(loginEmail: user.email),
          signingState: getState().signingState.copyWith(signingSessions: []),
          walletsState: getState().walletsState.copyWith(
            wallets: [],
            coins: [],
            defaultWallet: null,
          ),
        ));
      } else {
        emit(getState().copyWith(
            userState: getState().userState.copyWith(loginEmail: user.email)));
      }
    } else {
      print('User is currently signed out!');
      emit(getState().copyWith(
          userState: getState().userState.copyWith(loginEmail: null)));
    }
  }

  _handleLogin(Login event) async {
    await getIt<UserService>().storeLoginEmail(event.email);
    emit(getState()
        .copyWith(userState: getState().userState.copyWith(authForm: 'login')));
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: event.email, password: event.password);
      if (userCred.user != null) {
        await handleAfterLogin(userCred);
      } else {
        kbus.fireE(
            this,
            Alert(
                message: "User not found, please check your email and password",
                level: AlertLevel.ERROR));
        emit(getState().copyWith(
            userState: getState()
                .userState
                .copyWith(loginEmail: null, authForm: 'login')));
      }
    } on FirebaseAuthException catch (error, stacktrace) {
      print(stacktrace);
      kbus.fireE(
          this,
          Alert(
              message: "Login failed ${error.message}",
              level: AlertLevel.ERROR));
      emit(getState().copyWith(
          userState: getState()
              .userState
              .copyWith(loginEmail: null, authForm: 'login')));
    }
  }

  _handleSendLogout(event) async {
    await FirebaseAuth.instance.signOut();
    emit(getState().copyWith(
        userState: getState()
            .userState
            .copyWith(loginEmail: null, authForm: 'login')));
  }

  _handleSwitchAuthForm(SwitchAuthForm event) {
    emit(getState().copyWith(
        userState: getState().userState.copyWith(authForm: event.form)));
  }

  _handleRegister(Register event) async {
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: event.email, password: event.password);
      if (userCred.user != null) {
        await handleAfterLogin(userCred);
      } else {
        kbus.fireE(
            this,
            Alert(
                message: "User not found, please check your email and password",
                level: AlertLevel.ERROR));
        emit(getState().copyWith(
            userState: getState()
                .userState
                .copyWith(loginEmail: null, authForm: 'login')));
      }
    } on FirebaseAuthException catch (error, stacktrace) {
      print(stacktrace);
      kbus.fireE(
          this,
          Alert(
              message: "Register failed ${error.message}",
              level: AlertLevel.ERROR));
      emit(getState().copyWith(
          userState: getState()
              .userState
              .copyWith(loginEmail: null, authForm: 'login')));
    }
  }

  Future<void> handleAfterLogin(UserCredential userCred) async {
    if (userCred.user!.emailVerified == false) {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      scheduleCheckEmailVerification(userCred);
      emit(getState().copyWith(
          userState: getState()
              .userState
              .copyWith(loginEmail: null, authForm: 'verifyEmail')));
    } else {
      userCheckTimer?.cancel();
      emit(getState().copyWith(
          userState: getState()
              .userState
              .copyWith(loginEmail: userCred.user!.email, authForm: 'login')));
    }
  }

  void scheduleCheckEmailVerification(UserCredential userCred) {
    userCheckTimer ??=
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      if ((userCred.user?.emailVerified ?? false) == false) {
        print("checking email verification...");
        await userCred.user?.reload();
      }
    });
  }

  _handleForgetPassword(ForgetPassword event) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
    kbus.fireE(
        this,
        Alert(
            message:
                "Password reset email sent to ${event.email}, please check your email",
            level: AlertLevel.INFO));
  }
}
