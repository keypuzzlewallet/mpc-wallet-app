import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/blockchain/config/config_for_blockchain.dart';
part 'coin_config.g.dart';
@JsonSerializable()
@CopyWith()
class CoinConfig extends Equatable implements Event, Action {
  final Coin coin; // coin
  final String coinName; // Coin Name
  final String priceFeedId; // ID of price feed to use for this coin
  final List<ConfigForBlockchain> configForBlockchain; // configForBlockchain

  CoinConfig ({required this.coin, required this.coinName, required this.priceFeedId, required this.configForBlockchain});

  @override
  List<Object?> get props => [coin, coinName, priceFeedId, configForBlockchain];

  @override
  String toString() {
    return 'CoinConfig{coin: $coin, coinName: $coinName, priceFeedId: $priceFeedId, configForBlockchain: $configForBlockchain}';
  }
  factory CoinConfig.fromJson(Map<String, dynamic> json) => _$CoinConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CoinConfigToJson(this);
  @override
  String getName() => name();
  static String name() => "CoinConfig";
}

