import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/forget_password.dart';
import 'package:mobileapp/actions/login.dart';
import 'package:mobileapp/actions/register.dart';
import 'package:mobileapp/actions/send_logout.dart';
import 'package:mobileapp/actions/switch_auth_form.dart';
import 'package:mobileapp/actions/update_hot_wallet.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/screens/v1/views/apps_screen.dart';
import 'package:mobileapp/screens/v1/views/settings_screen.dart';
import 'package:mobileapp/screens/v1/views/signing_list_screen.dart';
import 'package:mobileapp/screens/v1/views/wallet_screen.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/theme/constant.dart';

class NavItem {
  final String title;
  final IconData iconData;

  NavItem(this.title, this.iconData);
}

class FullAppController extends FxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  int currentIndex = 0;
  bool passwordVisible = false;

  final TickerProvider tickerProvider;

  late List<NavItem> navItems = [
    NavItem('Wallet', AppIcons.wallet),
    NavItem('Signings', AppIcons.signature),
    NavItem('Apps', AppIcons.apps),
    NavItem('Settings', AppIcons.settings),
  ];
  late List<Widget> items = [
    const WalletScreen(),
    const SigningListScreen(),
    const AppsScreen(),
    const SettingsScreen()
  ];
  late TabController tabController = TabController(
      length: navItems.length, vsync: tickerProvider, initialIndex: 0);


  FullAppController(this.tickerProvider);

  @override
  void initState() {
    super.initState();
    tabController.addListener(handleTabSelection);
    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
        update();
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
        update();
      }
    });
    getIt.registerSingleton<TabController>(tabController);
  }

  handleTabSelection() {
    currentIndex = tabController.index;
    update();
  }

  @override
  String getTag() {
    return "full_app_controller";
  }

  signIn() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    getIt<KbusClient>().action(this, Login(emailController.text, passwordController.text));
    passwordController.text = '';
    password2Controller.text = '';
  }

  stayOffline() async {
    bool authenticated = await getIt<LocalAuthentication>().authenticate(
      localizedReason: 'Scan your biometric to authenticate',
    );
    if (authenticated) {
      getIt<KbusClient>().action(this, UpdateHotWallet(false));
    }
    passwordController.text = '';
    password2Controller.text = '';
  }

  tryAgain() {
    getIt<KbusClient>().action(this, SendLogout());
    passwordController.text = '';
    password2Controller.text = '';
  }

  switchAuthForm(String form) {
    getIt<KbusClient>().action(this, SwitchAuthForm(form));
    passwordController.text = '';
    password2Controller.text = '';
  }

  void switchPasswordVisible() {
    passwordVisible = !passwordVisible;
  }

  register() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    if (passwordController.text != password2Controller.text) {
      getIt<KbusClient>().action(this, Alert(message: 'Passwords do not match', level: AlertLevel.ERROR));
      return;
    }
    getIt<KbusClient>().action(this, Register(emailController.text, passwordController.text));
    passwordController.text = '';
    password2Controller.text = '';
  }

  forgetPassword() {
    if (emailController.text.isEmpty) {
      return;
    }
    getIt<KbusClient>().action(this, ForgetPassword(emailController.text));
    passwordController.text = '';
    password2Controller.text = '';
  }
}
