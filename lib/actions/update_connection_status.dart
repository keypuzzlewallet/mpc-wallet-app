import 'package:flutter/material.dart' as material;
import 'package:mobileapp/models/action.dart';

class UpdateConnectionStatus extends Action {
  final bool connected;

  UpdateConnectionStatus(this.connected);

  @override
  String toString() {
    return "[connected=$connected]";
  }
}
