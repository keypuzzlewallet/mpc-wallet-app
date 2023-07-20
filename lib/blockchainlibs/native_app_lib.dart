import 'dart:ffi'; // For FFI
import 'dart:io';

class NativeAppLib {
  static final DynamicLibrary nativeBlockchainLib = Platform.isAndroid
      ? DynamicLibrary.open('libblockchain_lib.so')
      : DynamicLibrary.process();
  static final DynamicLibrary nativeTssLib = Platform.isAndroid
      ? DynamicLibrary.open('libtssv3.so')
      : DynamicLibrary.process();
}
