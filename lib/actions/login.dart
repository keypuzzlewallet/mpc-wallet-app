import 'package:flutter/material.dart' as material;
import 'package:mobileapp/models/action.dart';

class Login extends Action {
  final String email;
  final String password;

  Login(this.email, this.password);

  @override
  String toString() {
    return "[email=$email,password=***]";
  }
}
