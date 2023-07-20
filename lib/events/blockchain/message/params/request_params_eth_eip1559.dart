import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
part 'request_params_eth_eip1559.g.dart';
@JsonSerializable()
@CopyWith()
class RequestParamsEthEip1559 extends Equatable implements Event, Action {
  final String chainId; // specify chain id for blockchain that may have different chain id in mainnet and testnet e.g. ETH
  final int nonce; // account nonce number
  @BigDecimalConverter()
  final BigDecimal baseGasFee; // base gas price
  @BigDecimalConverter()
  final BigDecimal priorityFee; // priority fee for transaction

  RequestParamsEthEip1559 ({required this.chainId, required this.nonce, required this.baseGasFee, required this.priorityFee});

  @override
  List<Object?> get props => [chainId, nonce, baseGasFee, priorityFee];

  @override
  String toString() {
    return 'RequestParamsEthEip1559{chainId: $chainId, nonce: $nonce, baseGasFee: $baseGasFee, priorityFee: $priorityFee}';
  }
  factory RequestParamsEthEip1559.fromJson(Map<String, dynamic> json) => _$RequestParamsEthEip1559FromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RequestParamsEthEip1559ToJson(this);
  @override
  String getName() => name();
  static String name() => "RequestParamsEthEip1559";
}

