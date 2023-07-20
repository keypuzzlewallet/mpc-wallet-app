import 'package:flutter/material.dart' as material;
import 'package:mobileapp/models/action.dart';

// trigger when a controller is loaded
class ControllerLoaded extends Action {
  final material.BuildContext context;
  final String controllerTag;

  ControllerLoaded(this.context, this.controllerTag);

  @override
  String toString() {
    return "[controllerTag=$controllerTag]";
  }
}
