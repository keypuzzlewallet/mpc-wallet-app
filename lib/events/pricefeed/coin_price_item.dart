import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
import 'package:mobileapp/events/enums/fiat.dart';
part 'coin_price_item.g.dart';
@JsonSerializable()
@CopyWith()
class CoinPriceItem extends Equatable implements Event, Action {
  final Fiat fiat; // fiat
  @BigDecimalConverter()
  final BigDecimal price; // price

  CoinPriceItem ({required this.fiat, required this.price});

  @override
  List<Object?> get props => [fiat, price];

  @override
  String toString() {
    return 'CoinPriceItem{fiat: $fiat, price: $price}';
  }
  factory CoinPriceItem.fromJson(Map<String, dynamic> json) => _$CoinPriceItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CoinPriceItemToJson(this);
  @override
  String getName() => name();
  static String name() => "CoinPriceItem";
}

