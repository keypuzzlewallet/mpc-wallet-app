import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/services/kbus.dart';

class PasswordRequestController extends FxController {
  var password = "";

  PasswordRequestController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "password_request_controller";
  }

  void goBack() {
    Navigator.pop(context, "");
  }

  void onEnterPassword(String p) {
    password = p;
  }

  void submit() {
    Navigator.pop(context, password);
  }
}
