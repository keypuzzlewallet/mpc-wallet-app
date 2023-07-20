import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class CreatePasswordController extends FxController {
  var passwordStrength = ValueNotifier<PasswordStrength?>(null);
  var isPasswordGood = false;
  var password = "";
  var reEnterPassword = "";

  CreatePasswordController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "create_password_controller";
  }

  void goBack() {
    Navigator.pop(context, "");
  }

  void onEnterPassword(String p) {
    password = p;
    passwordStrength.value = PasswordStrength.calculate(text: password);
    isPasswordGood = passwordStrength.value == PasswordStrength.secure ||
        passwordStrength.value == PasswordStrength.strong;
  }

  void onReEnterPassword(String p) {
    reEnterPassword = p;
  }

  void submit() {
    if (password != reEnterPassword) {
      getIt<KbusClient>().action(this,
          Alert(level: AlertLevel.ERROR, message: "passwords are not matched"));
    } else if (!isPasswordGood) {
      getIt<KbusClient>().action(
          this,
          Alert(
              level: AlertLevel.ERROR,
              message: "password is not strong enough"));
    } else {
      Navigator.pop(context, password);
    }
  }
}
