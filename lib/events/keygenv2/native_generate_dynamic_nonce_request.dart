import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/keygenv2/encrypted_local_key.dart';
part 'native_generate_dynamic_nonce_request.g.dart';
@JsonSerializable()
@CopyWith()
class NativeGenerateDynamicNonceRequest extends Equatable implements Event, Action {
  final int port; // callback port to report the final keygen result
  final String address; // address to report the final keygen result
  final String room; // address to report the final keygen result
  final String requestId; // requestId to easily identify the request
  final String token; // token to authenticate the request
  final String password; // password to dencrypt the private key
  final int nonceStartIndex; // nonce start index. This is 0 base and starting from the last previous generated nonce. For example, previous generated from 0 with 100 nonce. the next value starting from 100
  final int nonceSize; // Number of nonces to generate
  final KeyScheme keyScheme; // keyScheme
  final EncryptedLocalKey encryptedLocalKey; // encryptedLocalKey

  NativeGenerateDynamicNonceRequest ({required this.port, required this.address, required this.room, required this.requestId, required this.token, required this.password, required this.nonceStartIndex, required this.nonceSize, required this.keyScheme, required this.encryptedLocalKey});

  @override
  List<Object?> get props => [port, address, room, requestId, token, password, nonceStartIndex, nonceSize, keyScheme, encryptedLocalKey];

  @override
  String toString() {
    return 'NativeGenerateDynamicNonceRequest{port: $port, address: $address, room: $room, requestId: $requestId, token: $token, password: $password, nonceStartIndex: $nonceStartIndex, nonceSize: $nonceSize, keyScheme: $keyScheme, encryptedLocalKey: $encryptedLocalKey}';
  }
  factory NativeGenerateDynamicNonceRequest.fromJson(Map<String, dynamic> json) => _$NativeGenerateDynamicNonceRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NativeGenerateDynamicNonceRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "NativeGenerateDynamicNonceRequest";
}

