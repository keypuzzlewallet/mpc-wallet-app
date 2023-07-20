import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
part 'request_params_eth_legacy.g.dart';
@JsonSerializable()
@CopyWith()
class RequestParamsEthLegacy extends Equatable implements Event, Action {
  @BigDecimalConverter()
  final BigDecimal gasFee; // gas price
  final String chainId; // specify chain id for blockchain that may have different chain id in mainnet and testnet e.g. ETH
  final int nonce; // account nonce number

  RequestParamsEthLegacy ({required this.gasFee, required this.chainId, required this.nonce});

  @override
  List<Object?> get props => [gasFee, chainId, nonce];

  @override
  String toString() {
    return 'RequestParamsEthLegacy{gasFee: $gasFee, chainId: $chainId, nonce: $nonce}';
  }
  factory RequestParamsEthLegacy.fromJson(Map<String, dynamic> json) => _$RequestParamsEthLegacyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestParamsEthLegacyToJson(this);
  @override
  String getName() => name();
  static String name() => "RequestParamsEthLegacy";
}

