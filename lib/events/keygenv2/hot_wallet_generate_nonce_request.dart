import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
part 'hot_wallet_generate_nonce_request.g.dart';
@JsonSerializable()
@CopyWith()
class HotWalletGenerateNonceRequest extends Equatable implements ClientRequestEvent, Action {
  final String pubkey; // pubkey that client request generate nonces
  final KeyScheme keyScheme; // keyScheme
  final int nonceStart; // nonceStart
  final int nonceSize; // nonceSize
  final String roomId; // roomId

  HotWalletGenerateNonceRequest ({required this.pubkey, required this.keyScheme, required this.nonceStart, required this.nonceSize, required this.roomId});

  @override
  List<Object?> get props => [pubkey, keyScheme, nonceStart, nonceSize, roomId];

  @override
  String toString() {
    return 'HotWalletGenerateNonceRequest{pubkey: $pubkey, keyScheme: $keyScheme, nonceStart: $nonceStart, nonceSize: $nonceSize, roomId: $roomId}';
  }
  factory HotWalletGenerateNonceRequest.fromJson(Map<String, dynamic> json) => _$HotWalletGenerateNonceRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HotWalletGenerateNonceRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "HotWalletGenerateNonceRequest";
}

