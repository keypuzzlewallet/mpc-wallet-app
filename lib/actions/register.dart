import 'package:flutter/material.dart' as material;
import 'package:mobileapp/models/action.dart';

class Register extends Action {
  final String email;
  final String password;

  Register(this.email, this.password);

  @override
  String toString() {
    return "[email=$email,password=***]";
  }
}
