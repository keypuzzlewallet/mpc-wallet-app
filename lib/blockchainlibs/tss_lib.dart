import 'dart:async';
import 'dart:convert';
import 'dart:ffi'; // For FFI
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:mobileapp/blockchainlibs/native_app_lib.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_result.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_with_scheme.dart';
import 'package:mobileapp/events/keygenv2/native_generate_dynamic_nonce_request.dart';
import 'package:mobileapp/events/keygenv2/native_keygen_request.dart';
import 'package:mobileapp/events/signing/native_signing_request.dart';
import 'package:mobileapp/events/signing/signing_state_base64.dart';

typedef CallbackFunc = Void Function(Pointer<Utf8> result);

typedef dartPostCObject = Pointer Function(
    Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>);

final Pointer<Utf8> Function(Pointer<Utf8>) _c_sign = NativeAppLib.nativeTssLib
    .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>("c_sign")
    .asFunction();

final void Function(Pointer<Utf8>) _nativeKeygen = NativeAppLib.nativeTssLib
    .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>("c_keygen")
    .asFunction();

final void Function(Pointer<Utf8>) _nativeGenerateNonce = NativeAppLib.nativeTssLib
    .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>("c_generate_nonce")
    .asFunction();

// assumes that _dl is the `DynamicLibrary`
final storeDartPostCObject =
    NativeAppLib.nativeTssLib.lookupFunction<dartPostCObject, dartPostCObject>(
  'store_dart_post_cobject',
);

class TssLib {
  Future<EncryptedKeygenResult> keygen(NativeKeygenRequest request) async {
    var completer = Completer<String>();
    final sendPort = _singleCompletePort(completer);
    _nativeKeygen(
        jsonEncode(request.copyWith.port(sendPort.nativePort)).toNativeUtf8());
    final responseStr = await completer.future;
    if (responseStr.startsWith("error:")) {
      throw Exception(responseStr.replaceFirst("error:", "").trim());
    }
    return EncryptedKeygenResult.fromJson(jsonDecode(responseStr));
  }

  Future<EncryptedKeygenWithScheme> generateNonce(NativeGenerateDynamicNonceRequest request) async {
    print("NativeGenerateDynamicNonceRequest ${request.toString()}");
    var completer = Completer<String>();
    final sendPort = _singleCompletePort(completer);
    _nativeGenerateNonce(
        jsonEncode(request.copyWith.port(sendPort.nativePort)).toNativeUtf8());
    final responseStr = await completer.future;
    if (responseStr.startsWith("error:")) {
      throw Exception(responseStr.replaceFirst("error:", "").trim());
    }
    return EncryptedKeygenWithScheme.fromJson(jsonDecode(responseStr));
  }

  SigningStateBase64 sign(NativeSigningRequest request) {
    var result = _c_sign(jsonEncode(request).toNativeUtf8()).toDartString();
    if (result.startsWith("error:")) {
      throw Exception(result.replaceFirst("error:", "").trim());
    }
    return SigningStateBase64.fromJson(jsonDecode(result));
  }

  SendPort _singleCompletePort<R, P>(
    Completer<R> completer, {
    FutureOr<R> Function(P message)? callback,
    Duration? timeout,
    FutureOr<R> Function()? onTimeout,
  }) {
    if (callback == null && timeout == null) {
      return _singleCallbackPort<Object>((response) {
        _castComplete<R>(completer, response);
      });
    }
    var responsePort = RawReceivePort();
    Timer? timer;
    if (callback == null) {
      responsePort.handler = (response) {
        responsePort.close();
        timer?.cancel();
        _castComplete<R>(completer, response);
      };
    } else {
      var zone = Zone.current;
      var action = zone.registerUnaryCallback((response) {
        try {
          // Also catch it if callback throws.
          completer.complete(callback(response as P));
        } catch (error, stack) {
          completer.completeError(error, stack);
        }
      });
      responsePort.handler = (response) {
        responsePort.close();
        timer?.cancel();
        zone.runUnary(action, response as P);
      };
    }
    if (timeout != null) {
      timer = Timer(timeout, () {
        responsePort.close();
        if (onTimeout != null) {
          /// workaround for incomplete generic parameters promotion.
          /// example is available in 'TimeoutFirst with invalid null' test
          try {
            completer.complete(Future.sync(onTimeout));
          } catch (e, st) {
            completer.completeError(e, st);
          }
        } else {
          completer
              .completeError(TimeoutException('Future not completed', timeout));
        }
      });
    }
    return responsePort.sendPort;
  }

  SendPort _singleCallbackPort<P>(void Function(P) callback) {
    var responsePort = RawReceivePort();
    var zone = Zone.current;
    callback = zone.registerUnaryCallback(callback);
    responsePort.handler = (response) {
      responsePort.close();
      zone.runUnary(callback, response as P);
    };
    return responsePort.sendPort;
  }

  void _castComplete<R>(Completer<R> completer, Object? value) {
    try {
      completer.complete(value as R);
    } catch (error, stack) {
      completer.completeError(error, stack);
    }
  }

  TssLib() {
    storeDartPostCObject(NativeApi.postCObject);
  }
}
