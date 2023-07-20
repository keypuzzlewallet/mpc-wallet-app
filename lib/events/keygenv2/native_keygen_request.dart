import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'native_keygen_request.g.dart';
@JsonSerializable()
@CopyWith()
class NativeKeygenRequest extends Equatable implements Event, Action {
  final int port; // callback port to report the final keygen result
  final String address; // address to report the final keygen result
  final String room; // address to report the final keygen result
  final int t; // threshold
  final int n; // total number of parties
  final String signerName; // signer name
  final String password; // password to encrypt the generated private key
  final String requestId; // requestId to easily identify the request
  final String token; // token to authenticate the request

  NativeKeygenRequest ({required this.port, required this.address, required this.room, required this.t, required this.n, required this.signerName, required this.password, required this.requestId, required this.token});

  @override
  List<Object?> get props => [port, address, room, t, n, signerName, password, requestId, token];

  @override
  String toString() {
    return 'NativeKeygenRequest{port: $port, address: $address, room: $room, t: $t, n: $n, signerName: $signerName, password: $password, requestId: $requestId, token: $token}';
  }
  factory NativeKeygenRequest.fromJson(Map<String, dynamic> json) => _$NativeKeygenRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NativeKeygenRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "NativeKeygenRequest";
}

