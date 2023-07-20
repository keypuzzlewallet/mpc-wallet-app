import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/pricefeed/coin_price_item.dart';
part 'coin_price.g.dart';
@JsonSerializable()
@CopyWith()
class CoinPrice extends Equatable implements Event, Action {
  final Coin coin; // coin
  final List<CoinPriceItem> coinPriceItems; // coinPriceItems

  CoinPrice ({required this.coin, required this.coinPriceItems});

  @override
  List<Object?> get props => [coin, coinPriceItems];

  @override
  String toString() {
    return 'CoinPrice{coin: $coin, coinPriceItems: $coinPriceItems}';
  }
  factory CoinPrice.fromJson(Map<String, dynamic> json) => _$CoinPriceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CoinPriceToJson(this);
  @override
  String getName() => name();
  static String name() => "CoinPrice";
}

