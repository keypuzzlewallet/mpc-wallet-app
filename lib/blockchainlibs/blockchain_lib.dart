import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ffi'; // For FFI

import 'package:ffi/ffi.dart';
import 'package:mobileapp/blockchainlibs/native_app_lib.dart';
import 'package:mobileapp/events/blockchain/message/get_address_request.dart';
import 'package:mobileapp/events/blockchain/message/get_address_result.dart';
import 'package:mobileapp/events/blockchain/message/verify_transaction_request.dart';
import 'package:mobileapp/events/blockchain/message/verify_transaction_result.dart';

class BlockchainLib {
  final Pointer<Utf8> Function(Pointer<Utf8> jsonAddressRequest) _getAddress =
      NativeAppLib.nativeBlockchainLib
          .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
              "get_address")
          .asFunction();
  final Pointer<Utf8> Function(Pointer<Utf8> jsonAddressRequest) _verify =
      NativeAppLib.nativeBlockchainLib
          .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
              "verify")
          .asFunction();

  GetAddressResult getAddress(GetAddressRequest req) {
    var result = _getAddress(jsonEncode(req).toNativeUtf8()).toDartString();
    if (result.startsWith("error:")) {
      throw Exception(result.replaceFirst("error:", "").trim());
    }
    return GetAddressResult.fromJson(
        jsonDecode(result));
  }

  VerifyTransactionResult verify(VerifyTransactionRequest req) {
    var result = _verify(jsonEncode(req).toNativeUtf8()).toDartString();
    if (result.startsWith("error:")) {
      throw Exception(result.replaceFirst("error:", "").trim());
    }
    return VerifyTransactionResult.fromJson(
        jsonDecode(result));
  }
}
