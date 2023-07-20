import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
part 'blockchain_coin_config.g.dart';
@JsonSerializable()
@CopyWith()
class BlockchainCoinConfig extends Equatable implements Event, Action {
  final Coin coin; // coin
  final String coinName; // Coin Name
  final String priceFeedId; // ID of price feed to use for this coin
  final Blockchain blockchain; // blockchain
  final int decimals; // decimals
  final bool isNative; // whether the coin is native to the blockchain
  final String? contractAddress; // address of token contract to interact with
  final List<String> flags; // flags
  final bool enabled; // enabled

  BlockchainCoinConfig ({required this.coin, required this.coinName, required this.priceFeedId, required this.blockchain, required this.decimals, required this.isNative, this.contractAddress, required this.flags, required this.enabled});

  @override
  List<Object?> get props => [coin, coinName, priceFeedId, blockchain, decimals, isNative, contractAddress, flags, enabled];

  @override
  String toString() {
    return 'BlockchainCoinConfig{coin: $coin, coinName: $coinName, priceFeedId: $priceFeedId, blockchain: $blockchain, decimals: $decimals, isNative: $isNative, contractAddress: $contractAddress, flags: $flags, enabled: $enabled}';
  }
  factory BlockchainCoinConfig.fromJson(Map<String, dynamic> json) => _$BlockchainCoinConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BlockchainCoinConfigToJson(this);
  @override
  String getName() => name();
  static String name() => "BlockchainCoinConfig";
}

