import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
part 'estimate_fee_result.g.dart';
@JsonSerializable()
@CopyWith()
class EstimateFeeResult extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  @BigDecimalConverter()
  final BigDecimal lowEstimatedFee; // low estimated fee. The actual fee may be slightly different depending on the network conditions
  @BigDecimalConverter()
  final BigDecimal mediumEstimatedFee; // medium estimated fee. The actual fee may be slightly different depending on the network conditions
  @BigDecimalConverter()
  final BigDecimal highEstimatedFee; // high estimated fee. The actual fee may be slightly different depending on the network conditions

  EstimateFeeResult ({required this.blockchain, required this.coin, required this.lowEstimatedFee, required this.mediumEstimatedFee, required this.highEstimatedFee});

  @override
  List<Object?> get props => [blockchain, coin, lowEstimatedFee, mediumEstimatedFee, highEstimatedFee];

  @override
  String toString() {
    return 'EstimateFeeResult{blockchain: $blockchain, coin: $coin, lowEstimatedFee: $lowEstimatedFee, mediumEstimatedFee: $mediumEstimatedFee, highEstimatedFee: $highEstimatedFee}';
  }
  factory EstimateFeeResult.fromJson(Map<String, dynamic> json) => _$EstimateFeeResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EstimateFeeResultToJson(this);
  @override
  String getName() => name();
  static String name() => "EstimateFeeResult";
}

