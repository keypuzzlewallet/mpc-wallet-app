import 'package:big_decimal/big_decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';

import '../../events/enums/coin.dart';

part 'coin_data.g.dart';

@JsonSerializable()
class CoinData extends Equatable {
  Blockchain blockchain;
  Coin coin;
  String address;
  @BigDecimalConverter()
  BigDecimal? balance;

  CoinData(this.blockchain, this.coin, this.address, this.balance);

  factory CoinData.fromJson(Map<String, dynamic> json) =>
      _$CoinDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CoinDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  List<Object> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object)
      .toList();
}
