import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:big_decimal/big_decimal.dart';
import 'package:cbor/cbor.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

String shortAddress(String input, {int size = 4}) {
  if (input.length > size) {
    return "${input.substring(0, size)}...${input.substring(input.length - size, input.length)}";
  } else {
    return input;
  }
}

String formatNumber(BigDecimal input, {int size = 8}) {
  var format = NumberFormat("0.00######", "en_US");
  return format.format(input.withScale(size, roundingMode: RoundingMode.HALF_UP).toDouble());
}

String generateId(String prefix, {int len = 16}) {
  var r = Random();
  const digits = '0123456789';
  return prefix.toUpperCase() +
      List.generate(len, (index) => digits[r.nextInt(digits.length)]).join();
}

// function to compress json
String compressJson(Map<String, dynamic> json) {
  var value = CborValue(json);
  var cborValue = cbor.encode(value);
  var compressed = gzip.encode(cborValue);
  return base64Encode(compressed);
}

// function to decompress json
Map<String, dynamic> decompressJson(String compressed) {
  var decoded = base64Decode(compressed);
  var decompressed = gzip.decode(decoded);
  var cborValue = cbor.decode(decompressed);
  return cborValue.toJson()! as Map<String, dynamic>;
}

Future<String> getAppVersion() async {
  var packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

BigDecimal hexToBigDecimal(String hex) {
  return BigDecimal.fromBigInt(BigInt.parse(hex.replaceAll("0x", ""), radix: 16));
}
