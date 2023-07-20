import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/pricefeed/coin_price.dart';
part 'coin_prices.g.dart';
@JsonSerializable()
@CopyWith()
class CoinPrices extends Equatable implements Event, Action {
  final List<CoinPrice> coinPrices; // coinPrices

  CoinPrices ({required this.coinPrices});

  @override
  List<Object?> get props => [coinPrices];

  @override
  String toString() {
    return 'CoinPrices{coinPrices: $coinPrices}';
  }
  factory CoinPrices.fromJson(Map<String, dynamic> json) => _$CoinPricesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CoinPricesToJson(this);
  @override
  String getName() => name();
  static String name() => "CoinPrices";
}

