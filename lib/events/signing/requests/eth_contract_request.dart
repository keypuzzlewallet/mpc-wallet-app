import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
part 'eth_contract_request.g.dart';
@JsonSerializable()
@CopyWith()
class EthContractRequest extends Equatable implements Event, Action {
  final String toAddress; // smart contract address
  @BigDecimalConverter()
  final BigDecimal amount; // amount of native coin that we send to the contract
  @BigDecimalConverter()
  final BigDecimal gasLimit; // gas limit provided by contract
  final String data; // smart contract data

  EthContractRequest ({required this.toAddress, required this.amount, required this.gasLimit, required this.data});

  @override
  List<Object?> get props => [toAddress, amount, gasLimit, data];

  @override
  String toString() {
    return 'EthContractRequest{toAddress: $toAddress, amount: $amount, gasLimit: $gasLimit, data: $data}';
  }
  factory EthContractRequest.fromJson(Map<String, dynamic> json) => _$EthContractRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EthContractRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "EthContractRequest";
}

