import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobileapp/screens/v1/views/full_app_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/user_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class FullAppScreen extends StatefulWidget {
  const FullAppScreen({Key? key}) : super(key: key);

  @override
  _FullAppScreenState createState() => _FullAppScreenState();
}

class _FullAppScreenState extends State<FullAppScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late FullAppController controller;
  late ThemeData theme;

  _FullAppScreenState();

  @override
  void initState() {
    super.initState();
    controller = FullAppController(this);
    // controller = FxControllerStore.putOrFind(FullAppController(this));
    theme = AppTheme.nftTheme;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      try {
        await FirebaseAuth.instance.currentUser?.reload();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FullAppController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return BlocSelector<AppGlobalBloc, AppGlobalState, bool>(
            selector: (state) => state.settingsState.isHotWallet,
            builder: (context, isHotWallet) {
              return BlocSelector<AppGlobalBloc, AppGlobalState, UserState>(
                selector: (state) => state.userState,
                builder: (context, userState) =>
                    isHotWallet && userState.loginEmail == null
                        ? buildLogin(userState)
                        : buildMainScreen(controller),
              );
            },
          );
        });
  }

  Scaffold buildMainScreen(FullAppController controller) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: TabBarView(
            controller: controller.tabController,
            children: controller.items,
          )),
          FxContainer(
            bordered: true,
            enableBorderRadius: false,
            border: Border(
                top: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                    style: BorderStyle.solid)),
            padding: FxSpacing.xy(12, 16),
            color: theme.scaffoldBackgroundColor,
            child: TabBar(
              controller: controller.tabController,
              indicator: FxTabIndicator(
                  indicatorColor: theme.colorScheme.primary,
                  indicatorHeight: 3,
                  radius: 3,
                  indicatorStyle: FxTabIndicatorStyle.rectangle,
                  yOffset: -18),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: theme.colorScheme.primary,
              tabs: buildTab(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];

    for (int i = 0; i < controller.navItems.length; i++) {
      bool selected = controller.currentIndex == i;
      tabs.add(Icon(controller.navItems[i].iconData,
          size: 20,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onBackground));
    }
    return tabs;
  }

  Widget buildLogin(UserState userState) {
    switch (userState.authForm) {
      case "login":
        return loginContainer();
      case "register":
        return buildRegisterForm();
      case "forgotPassword":
        return buildForgetPasswordForm();
      case "verifyEmail":
        return verifyInstruction();
      default:
        return loginContainer();
    }
  }

  buildForgetPasswordForm() {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Center(
                    child: FxText.titleLarge("Forgot Password?", fontWeight: 600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: controller.emailController,
                    style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Email address",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      prefixIcon: Icon(
                        MdiIcons.emailOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                FxSpacing.height(20),
                FxButton.block(
                  elevation: 0,
                  borderRadiusAll: 4,
                  onPressed: () => controller.forgetPassword(),
                  child: FxText.bodyMedium("Reset Password",
                      color: theme.colorScheme.onPrimary,
                      letterSpacing: 0.5,
                      fontWeight: 600),
                ),
                FxSpacing.height(20),
                Center(
                  child: FxButton.text(
                    onPressed: () => controller.switchAuthForm("register"),
                    child: FxText.bodyMedium(
                      "I haven't an account",
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  buildRegisterForm() {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Center(
                    child: FxText.titleLarge("Create an Account", fontWeight: 600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: controller.emailController,
                    style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintStyle: FxTextStyle.bodyLarge(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      hintText: "Email address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      prefixIcon: Icon(
                        AppIcons.email,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: controller.passwordController,
                    style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    obscureText: !controller.passwordVisible,
                    decoration: InputDecoration(
                      hintStyle: FxTextStyle.bodyLarge(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      prefixIcon: Icon(
                        MdiIcons.lockOutline,
                        size: 22,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            controller.switchPasswordVisible();
                          });
                        },
                        child: Icon(
                          controller.passwordVisible
                              ? MdiIcons.eyeOutline
                              : MdiIcons.eyeOffOutline,
                          size: 22,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: controller.password2Controller,
                    style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    obscureText: !controller.passwordVisible,
                    decoration: InputDecoration(
                      hintStyle: FxTextStyle.bodyLarge(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      hintText: "Enter Password again",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      prefixIcon: Icon(
                        MdiIcons.lockOutline,
                        size: 22,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            controller.switchPasswordVisible();
                          });
                        },
                        child: Icon(
                          controller.passwordVisible
                              ? MdiIcons.eyeOutline
                              : MdiIcons.eyeOffOutline,
                          size: 22,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                FxSpacing.height(20),
                FxButton.block(
                  elevation: 0,
                  borderRadiusAll: 4,
                  onPressed: () => controller.register(),
                  child: FxText.bodyMedium("Register",
                      fontWeight: 600, color: theme.colorScheme.onPrimary),
                ),
                FxSpacing.height(20),
                Center(
                  child: FxButton.text(
                    onPressed: () => controller.switchAuthForm('login'),
                    child: FxText.bodyMedium("I've already an account"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  verifyInstruction() {
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Column(
          children: <Widget>[
            const Image(
              image: AssetImage('./assets/images/maintenance.png'),
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: FxText.bodyLarge("We sent you an email!",
                  color: theme.colorScheme.onBackground,
                  fontWeight: 600,
                  letterSpacing: 0.2),
            ),
            Container(
              margin: const EdgeInsets.only(left: 56, right: 56, top: 24),
              child: FxText.bodyMedium(
                "Tap on a link in the email to activate your account.",
                letterSpacing: 0,
                fontWeight: 500,
                height: 1.2,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 56, right: 56, top: 24),
              child: FxButton.outlined(
                  onPressed: () => controller.tryAgain(),
                  child: FxText.bodyMedium("Return to login")),
            )
          ],
        ));
  }

  loginContainer() {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Center(
                    child: FxText.titleLarge("Welcome Back", fontWeight: 600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: controller.emailController,
                    style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Email address",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      prefixIcon: Icon(
                        MdiIcons.emailOutline,
                        size: 22,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: controller.passwordController,
                    autofocus: false,
                    obscureText: !controller.passwordVisible,
                    style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: 500),
                    decoration: InputDecoration(
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      prefixIcon: Icon(
                        MdiIcons.lockOutline,
                        size: 22,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            controller.switchPasswordVisible();
                          });
                        },
                        child: Icon(
                          controller.passwordVisible
                              ? MdiIcons.eyeOutline
                              : MdiIcons.eyeOffOutline,
                          size: 22,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(0),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                FxSpacing.height(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: FxButton.text(
                        padding: FxSpacing.zero,
                        onPressed: () => controller.switchAuthForm("register"),
                        child: FxText.bodyMedium(
                          "I haven't an account",
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      child: FxButton.text(
                        padding: FxSpacing.zero,
                        onPressed: () => controller.switchAuthForm("forgotPassword"),
                        child: FxText.bodyMedium(
                          "Forgot Password ?",
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                ),
                FxSpacing.height(20),
                FxButton.block(
                  elevation: 0,
                  borderRadiusAll: 4,
                  onPressed: () => controller.signIn(),
                  child: FxText.bodyMedium(
                    "Sign in",
                    fontWeight: 600,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                FxSpacing.height(20),
                Center(
                  child: FxText("OR"),
                ),
                FxSpacing.height(20),
                FxButton.block(
                  elevation: 0,
                  borderRadiusAll: 4,
                  onPressed: () => controller.stayOffline(),
                  child: FxText.bodyMedium(
                    "Use Offline Wallet",
                    fontWeight: 600,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
