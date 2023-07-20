import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

Future<String> encrypt(String plaintext, String secretInput) async {
  final nonce = DateTime.now().millisecondsSinceEpoch;
  return await encryptWithNonce(plaintext, secretInput, nonce);
}

Uint8List _getKeyFromPassword(String password) {
  return Uint8List.fromList(sha256.convert(utf8.encode(password)).bytes);
}

Uint8List _deriveIvFromNonce(int nonce) {
  return Uint8List(12)..buffer.asByteData().setInt64(4, nonce, Endian.big);
}

Future<String> encryptWithNonce(String plaintext, String secretInput, int nonce) async {
  final algorithm = AesGcm.with256bits(nonceLength: 12);
  final key = _getKeyFromPassword(secretInput);
  final iv = _deriveIvFromNonce(nonce);
  final encrypted = await algorithm.encrypt(plaintext.codeUnits, secretKey: SecretKey(key.toList()), nonce: iv);
  final List<int> result = [];
  result.addAll(encrypted.cipherText);
  result.addAll(encrypted.mac.bytes);
  return "$nonce:${base64Encode(result)}";
}

Future<String> decrypt(String encryptedText, String secretInput) async {
  final parts = encryptedText.split(":");
  if (parts.length != 2) {
    throw Exception("Invalid encrypted text");
  }
  final nonce = int.parse(parts[0]);
  return await decryptWithNonce(parts[1], secretInput, nonce);
}

Future<String> decryptWithNonce(String encryptedText, String secretInput, int nonce) async {
  final algorithm = AesGcm.with256bits();
  final key = _getKeyFromPassword(secretInput);
  final iv = _deriveIvFromNonce(nonce);
  final encryptedBytes = base64Decode(encryptedText);
  final cipherTextBytes = encryptedBytes.sublist(0, encryptedBytes.length - 16);
  final macBytes = encryptedBytes.sublist(encryptedBytes.length - 16);
  var decrypted = await algorithm.decrypt(SecretBox(cipherTextBytes, nonce: iv, mac: Mac(macBytes)), secretKey: SecretKey(key.toList()));
  return String.fromCharCodes(decrypted);
}
