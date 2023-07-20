import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/send_logout.dart';
import 'package:mobileapp/actions/submit_new_nonce.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/backup_wallet.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/screens/v1/views/address_list_screen.dart';
import 'package:mobileapp/screens/v1/views/create_password_screen.dart';
import 'package:mobileapp/screens/v1/views/create_wallet_options_screen.dart';
import 'package:mobileapp/screens/v1/views/join_new_wallet_screen.dart';
import 'package:mobileapp/screens/v1/views/password_request_screen.dart';
import 'package:mobileapp/screens/v1/views/security_settings_screen.dart';
import 'package:mobileapp/screens/v1/views/wait_new_wallet_screen.dart';
import 'package:mobileapp/screens/v1/views/wallet_select_screen.dart';
import 'package:mobileapp/services/encryption.dart' as encryption;
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:path_provider/path_provider.dart';

class SettingsController extends FxController {
  SettingsController();

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
    return "settings_controller";
  }

  goToCreateNewWallet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateWalletOptionsScreen(),
      ),
    );
  }

  goToJoinCreateNewWallet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const JoinNewWalletScreen(),
      ),
    );
  }

  goToCreateNonceFormScreen() async {
    WalletEntity? wallet = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WalletSelectScreen(title: "Select a Wallet"),
      ),
    );
    if (wallet != null) {
      getIt<KbusClient>().action(
          this,
          SubmitNewNonce(wallet, KeyScheme.EDDSA));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const WaitNewWalletScreen(),
        ),
      );
    }
  }

  goToBackupScreen() async {
    WalletEntity? wallet = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WalletSelectScreen(title: "Select Wallet to Backup"),
      ),
    );
    if (wallet != null) {
      onSelectBackupWallet(wallet);
    }
  }

  onSelectBackupWallet(WalletEntity wallet) async {
    Directory initialDirectory = await getApplicationDocumentsDirectory();
    String? directory = await FilePicker.platform.getDirectoryPath(
      initialDirectory: initialDirectory.path,
    );

    if (directory != null) {
      var protectPassword = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CreatePasswordScreen(),
        ),
      );
      if (protectPassword != "") {
        bool authenticated = await getIt<LocalAuthentication>().authenticate(
          localizedReason: 'Scan your biometric to authenticate',
        );
        if (authenticated) {
          var backupFileData = jsonEncode(BackupWallet(
                  walletEntity: wallet,
                  secret: await encryption.encrypt(
                      await getIt<WalletService>()
                          .getEncryptionKey(wallet.walletId),
                      protectPassword))
              .toJson());
          await File(
                  "$directory/wallet_${wallet.walletId}_${wallet.partyId}_${DateTime.now().millisecondsSinceEpoch}.bak")
              .writeAsBytes(backupFileData.codeUnits);
          getIt<KbusClient>().action(
              this,
              Alert(
                  level: AlertLevel.INFO,
                  message:
                      "wallet ${wallet.walletId} backed up at $directory"));
        }
      } else {
        getIt<KbusClient>().action(
            this,
            Alert(
                level: AlertLevel.INFO,
                message: "Password is required to encrypt secret share"));
      }
    }
  }

  selectFileBackupToRestore() async {
    try {
      Directory initialDirectory = await getApplicationDocumentsDirectory();
      var backupFile = await FilePicker.platform
          .pickFiles(initialDirectory: initialDirectory.path);
      if (backupFile != null && backupFile.files.length == 1) {
        var file = File(backupFile.files.first.path!);
        var walletBackup = getIt<WalletService>().recoverWalletFromBackup(
            utf8.decode(file.readAsBytesSync().toList()));
        final password = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PasswordRequestScreen(),
          ),
        );
        if (password == "") {
          getIt<KbusClient>().action(
              this,
              Alert(
                  level: AlertLevel.ERROR,
                  message: "Can't use empty password"));
        } else {
          await getIt<WalletService>().storeWalletFromBackup(
              walletBackup.walletEntity,
              await encryption.decrypt(walletBackup.secret, password));
          getIt<KbusClient>().action(
              this,
              Alert(
                  level: AlertLevel.INFO,
                  message:
                      "wallet ${walletBackup.walletEntity.name} (${walletBackup.walletEntity.walletId}) restored"));
        }
      } else {
        getIt<KbusClient>().action(this,
            Alert(level: AlertLevel.INFO, message: "no restore file selected"));
      }
    } on Error catch (err) {
      print("Error while restoring file ${err.toString()}");
      getIt<KbusClient>().action(this,
          Alert(level: AlertLevel.INFO, message: "Error while restoring file"));
    }
  }

  gotoSecuritySettingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SecuritySettingsScreen(),
      ),
    );
  }

  gotoAddressListScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddressListScreen(),
      ),
    );
  }

  logout() {
    getIt<KbusClient>().action(this, SendLogout());
  }
}
