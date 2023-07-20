import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/blockchain/unspent_output.dart';
part 'request_params_ada.g.dart';
@JsonSerializable()
@CopyWith()
class RequestParamsAda extends Equatable implements Event, Action {
  final List<UnspentOutput> unspentOutputs; // used in UTXO transaction type e.g. BTC, LTC, BCH, DOGE
  final int ttl; // slot number when the transaction will be invalid. Calculate this by current slot + number of slots expect to be in the mempool.
  final int feeCoeff; // coeff value (unit) in fee linear coeff x bytes + constant. This finds in network parameters.
  final int feeConstant; // constant value (unit) in fee linear coeff x bytes + constant. This finds in network parameters.
  final int coinPerUtxoByte; // ada value (unit) per utxo byte. This finds in network parameters.

  RequestParamsAda ({required this.unspentOutputs, required this.ttl, required this.feeCoeff, required this.feeConstant, required this.coinPerUtxoByte});

  @override
  List<Object?> get props => [unspentOutputs, ttl, feeCoeff, feeConstant, coinPerUtxoByte];

  @override
  String toString() {
    return 'RequestParamsAda{unspentOutputs: $unspentOutputs, ttl: $ttl, feeCoeff: $feeCoeff, feeConstant: $feeConstant, coinPerUtxoByte: $coinPerUtxoByte}';
  }
  factory RequestParamsAda.fromJson(Map<String, dynamic> json) => _$RequestParamsAdaFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestParamsAdaToJson(this);
  @override
  String getName() => name();
  static String name() => "RequestParamsAda";
}

