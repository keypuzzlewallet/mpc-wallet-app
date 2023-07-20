import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
// final GlobalKey qrKey2 = GlobalKey(debugLabel: 'QR2');

class QrScanController extends FxController {
  Map<int, String> parts = {};
  final RegExp multiPartRegex = RegExp(r"(\d+):(\d+):(.*)");
  int total = 0;
  bool isCompleted = false;
  QRViewController? controller;

  QrScanController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "qr_scan_controller";
  }

  void goBack() {
    Navigator.pop(context, "");
  }

  void onQRViewCreated(Barcode scanData) async {
    if (isCompleted) {
      return;
    }
    var match = multiPartRegex.firstMatch(scanData.code ?? "");
    if (match != null) {
      var part = int.parse(match.group(1) ?? "");
      total = int.parse(match.group(2) ?? "");
      var data = match.group(3) ?? "";
      bool isNew = false;
      if (!parts.containsKey(part)) {
        isNew = true;
      }
      parts[part] = data;
      if (parts.length == total + 1) {
        isCompleted = true;
        parts = Map.fromEntries(
            parts.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
        var compressed = parts.values.join("");
        var uncompressed = decompressJson(compressed);

        update();
        await controller?.stopCamera();
        controller?.dispose();
        Navigator.pop(context, jsonEncode(uncompressed));
      } else if (isNew) {
        update();
      }
    } else {
      total = 1;
      parts[0] = scanData.code ?? "";
      update();
      await controller?.stopCamera();
      controller?.dispose();
      Navigator.pop(context, parts[0]);
    }
  }
}
