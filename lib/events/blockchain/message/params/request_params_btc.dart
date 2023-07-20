import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
import 'package:mobileapp/events/blockchain/unspent_output.dart';
part 'request_params_btc.g.dart';
@JsonSerializable()
@CopyWith()
class RequestParamsBtc extends Equatable implements Event, Action {
  final List<UnspentOutput> unspentOutputs; // used in UTXO transaction type e.g. BTC, LTC, BCH, DOGE
  @BigDecimalConverter()
  final BigDecimal feePerByte; // (BTC) fee per byte

  RequestParamsBtc ({required this.unspentOutputs, required this.feePerByte});

  @override
  List<Object?> get props => [unspentOutputs, feePerByte];

  @override
  String toString() {
    return 'RequestParamsBtc{unspentOutputs: $unspentOutputs, feePerByte: $feePerByte}';
  }
  factory RequestParamsBtc.fromJson(Map<String, dynamic> json) => _$RequestParamsBtcFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestParamsBtcToJson(this);
  @override
  String getName() => name();
  static String name() => "RequestParamsBtc";
}

