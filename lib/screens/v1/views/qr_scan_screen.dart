import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/qr_scan_controller.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({
    Key? key,
  }) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  late ThemeData theme;
  late QrScanController controller;

  _QrScanScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = QrScanController();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller.controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    print("dispose camera");
    controller.controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController c) {
    controller.controller = c;
    c.scannedDataStream.listen((scanData) {
      controller.onQRViewCreated(scanData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<QrScanController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
              // key: qrKey2,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leading: InkWell(
                  onTap: () => controller.goBack(),
                  child: const Icon(
                    AppIcons.back,
                    size: 20,
                  ),
                ),
                title: FxText.titleLarge(
                  "Scan QR Code",
                ),
                actions: const <Widget>[],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: FxSpacing.fromLTRB(
                      20, FxSpacing.safeAreaTop(context), 20, 0),
                  child: Column(children: <Widget>[
                    const Text(
                      'Please keep scanning QR codes until the progress is completed',
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 300,
                        width: 300,
                        child: Expanded(
                          flex: 5,
                          child: QRView(
                            onQRViewCreated: _onQRViewCreated,
                            key: qrKey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Progress',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${controller.parts.length} / ${controller.total + 1}',
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff0DC9AB),
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    )
                  ]),
                ),
              ));
        });
  }
}
