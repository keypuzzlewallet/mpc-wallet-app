import 'package:flutter/material.dart' as material;
import 'package:mobileapp/models/action.dart';

class ForgetPassword extends Action {
  final String email;

  ForgetPassword(this.email);

  @override
  String toString() {
    return "[email=$email]";
  }
}
