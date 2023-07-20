import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/settings_controller.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/user_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeData theme;
  late SettingsController controller;

  _SettingsScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = SettingsController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SettingsController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: FxText.titleLarge("Settings"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context), 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image(),
                    // FxSpacing.height(4),
                    // Align(
                    //     alignment: Alignment.center,
                    //     child: FxText.titleMedium(
                    //       "John Micheal",
                    //       fontWeight: 700,
                    //     )),
                    // FxSpacing.height(4),
                    // verified(),
                    FxSpacing.height(20),
                    settings(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        singleRow(
            AppIcons.newWallet,
            "Create Wallet",
            "Start a new session to create a wallet",
                () => controller.goToCreateNewWallet()),
        const Divider(),
        singleRow(
            AppIcons.joinNewWallet,
            "Join Wallet Creation",
            "Join a session to create new wallet. You will be come a signer.",
                () => controller.goToJoinCreateNewWallet()),
        const Divider(),
        singleRow(
            AppIcons.joinNewWallet,
            "Generate Pre-signatures",
            "This process requires wallet's members sync and generate new pre-signatures for future signings",
                () => controller.goToCreateNonceFormScreen()),
        const Divider(),
        singleRow(
            AppIcons.backupWallet,
            "Backup Private Share",
            "Backup your private share and generate a password encrypted file. This backup file can be used to recover on another device.",
                () => controller.goToBackupScreen()),
        const Divider(),
        singleRow(
            AppIcons.restoreWallet,
            "Restore Private Share",
            "Restore Private Share from a backup file.",
                () => controller.selectFileBackupToRestore()),
        const Divider(),
        singleRow(AppIcons.security, "Security", "Adjust security settings.",
                () => controller.gotoSecuritySettingScreen()),
        const Divider(),
        singleRow(
            AppIcons.addressList,
            "Address List",
            "Manage and whitelist addresses that are for withdrawing to.",
                () => controller.gotoAddressListScreen()),
        const Divider(),
        FxSpacing.height(16),
        BlocSelector<AppGlobalBloc, AppGlobalState, UserState>(
          selector: (state) => state.userState,
          builder: (context, userState) {
            if (userState.loginEmail != null) {
              return logout(userState.loginEmail!);
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget logout(String username) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          FxText(username),
          FxSpacing.height(8),
          FxButton.medium(
            onPressed: () => controller.logout(),
            elevation: 0,
            borderRadiusAll: Constant.containerRadius.xs,
            child: FxText.labelMedium(
                "Logout",
                color: theme.colorScheme.onPrimary,
                letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }

  Widget singleRow(IconData icon, String title, String subTitle,
      VoidCallback onTap) {
    return Padding(
      padding: FxSpacing.bottom(8),
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            FxContainer.rounded(
              paddingAll: 12,
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            FxSpacing.width(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodyMedium(
                    title,
                    fontWeight: 600,
                  ),
                  FxSpacing.height(2),
                  FxText.bodySmall(subTitle),
                ],
              ),
            ),
            FxSpacing.width(20),
            const Icon(
              AppIcons.forward,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
