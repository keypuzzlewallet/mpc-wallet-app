import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Simple stateful widget
class RotateQrImages extends StatefulWidget {
  final Map<String, dynamic> data;
  final int length;
  final double size;
  final Duration duration;

  const RotateQrImages(
      {super.key,
      required this.data,
      required this.length,
      required this.size,
      required this.duration});

  @override
  _RotateQrImagesState createState() =>
      _RotateQrImagesState(splitCodeToChunk(data, length));

  splitCodeToChunk(Map<String, dynamic> code, int lengthPerQr) {
    String data = compressJson(code);
    List<String> chunks = [];
    int start = 0;
    while (start < data.length) {
      if (start + lengthPerQr > data.length) {
        lengthPerQr = data.length - start;
      }
      chunks.add(data.substring(start, start + lengthPerQr));
      start += lengthPerQr;
    }
    return chunks;
  }
}

class _RotateQrImagesState extends State<RotateQrImages> {
  int index = 0;
  List<String> chunks;
  Timer? _timer;

  _RotateQrImagesState(this.chunks);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    // render image and switch to the next one every x seconds
    return Column(
      children: [
        QrImage(
          data: chunks.length > index
              ? "$index:${chunks.length - 1}:${chunks[index]}"
              : "",
          size: widget.size,
          version: QrVersions.auto,
        ),
        Center(
          child: Text(
            '${index + 1}/${chunks.length}',
          ),
        ),
      ],
    );
  }

  void startTimer() {
    // start timer to increase index every 6 seconds
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        index = (index + 1) % chunks.length;
      });
    });
  }

  void cancelTimer() {
    // cancel timer
    _timer?.cancel();
    _timer = null;
  }
}
