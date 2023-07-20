import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
part 'hot_wallet_keygen_request.g.dart';
@JsonSerializable()
@CopyWith()
class HotWalletKeygenRequest extends Equatable implements ClientRequestEvent, Action {
  final String keygenId; // keygenId
  final int numberOfMembers; // numberOfMembers
  final int threshold; // threshold
  final String walletName; // walletName
  final String roomId; // roomId
  final WalletCreationConfig walletCreationConfig; // walletCreationConfig

  HotWalletKeygenRequest ({required this.keygenId, required this.numberOfMembers, required this.threshold, required this.walletName, required this.roomId, required this.walletCreationConfig});

  @override
  List<Object?> get props => [keygenId, numberOfMembers, threshold, walletName, roomId, walletCreationConfig];

  @override
  String toString() {
    return 'HotWalletKeygenRequest{keygenId: $keygenId, numberOfMembers: $numberOfMembers, threshold: $threshold, walletName: $walletName, roomId: $roomId, walletCreationConfig: $walletCreationConfig}';
  }
  factory HotWalletKeygenRequest.fromJson(Map<String, dynamic> json) => _$HotWalletKeygenRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HotWalletKeygenRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "HotWalletKeygenRequest";
}

