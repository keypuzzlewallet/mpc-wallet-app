import 'package:flutter/material.dart' as material;
import 'package:mobileapp/models/action.dart';

class SwitchAuthForm extends Action {
  final String form;

  SwitchAuthForm(this.form);

  @override
  String toString() {
    return "[form=$form]";
  }
}
