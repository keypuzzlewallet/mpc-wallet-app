import 'package:flutter/material.dart';
import 'package:mobileapp/states/app_global_state.dart';

abstract class SubBloc {
  final Function(AppGlobalState) emit;
  final Function(BuildContext) setContext;
  AppGlobalState Function() getState;
  BuildContext? Function() getContext;

  SubBloc(this.getState, this.emit, this.setContext, this.getContext);
}
