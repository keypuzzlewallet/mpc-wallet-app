import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config_pubkey.dart';
part 'wallet_creation_config.g.dart';
@JsonSerializable()
@CopyWith()
class WalletCreationConfig extends Equatable implements Event, Action {
  final List<WalletCreationConfigPubkey> pubkeys; // wallet public keys
  final bool isMainnet; // isMainnet
  final bool isSegwit; // If this is set and value is true, wallet will create segwit address

  WalletCreationConfig ({required this.pubkeys, required this.isMainnet, required this.isSegwit});

  @override
  List<Object?> get props => [pubkeys, isMainnet, isSegwit];

  @override
  String toString() {
    return 'WalletCreationConfig{pubkeys: $pubkeys, isMainnet: $isMainnet, isSegwit: $isSegwit}';
  }
  factory WalletCreationConfig.fromJson(Map<String, dynamic> json) => _$WalletCreationConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WalletCreationConfigToJson(this);
  @override
  String getName() => name();
  static String name() => "WalletCreationConfig";
}

