import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/send_command.dart';
import 'package:mobileapp/actions/send_logout.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
import 'package:mobileapp/events/system/alert.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/sse_service.dart';
import 'package:mobileapp/states/sub_bloc.dart';

class CommonBloc extends SubBloc {
  final KbusClient kbus;
  final SseService sseService;

  CommonBloc(super.getState, super.emit, super.setContext, super.getContext, this.kbus,
      this.sseService) {
    kbus.onE<Alert>(this).listen((event) => handleAlert(event));
    kbus.onE<SendCommand>(this).listen((event) => handleSendCommand(event));
  }

  Future<void> handleAlert(Alert event) async {
    String msg = "${event.level.name}: ${event.message}";
    if (event.code == 401) {
      kbus.fireE(this, SendLogout());
    }
    BuildContext? buildContext = getContext();
    if (buildContext != null) {
      Color color = theme.colorScheme.onPrimary;
      Color background = theme.colorScheme.primary;
      if (event.level == AlertLevel.ERROR) {
        color = theme.colorScheme.onError;
        background = theme.colorScheme.error;
      } else if (event.level == AlertLevel.WARN) {
        color = theme.colorScheme.onSurface;
        background = theme.colorScheme.surface;
      }
      ScaffoldMessenger.of(buildContext).showSnackBar(
        SnackBar(
          content: FxText.titleSmall(event.message,
              color: color),
          backgroundColor: background,
          duration: const Duration(seconds: 10),
          showCloseIcon: true,
        ),
      );
    }
  }

  Future<void> handleSendCommand(SendCommand event) =>
      sseService.command(event.command);
}
