import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
part 'send_token_request.g.dart';
@JsonSerializable()
@CopyWith()
class SendTokenRequest extends Equatable implements Event, Action {
  final String toAddress; // toAddress
  final String tokenContractAddress; // tokenContractAddress
  @BigDecimalConverter()
  final BigDecimal amount; // amount
  final int decimals; // decimal places of token

  SendTokenRequest ({required this.toAddress, required this.tokenContractAddress, required this.amount, required this.decimals});

  @override
  List<Object?> get props => [toAddress, tokenContractAddress, amount, decimals];

  @override
  String toString() {
    return 'SendTokenRequest{toAddress: $toAddress, tokenContractAddress: $tokenContractAddress, amount: $amount, decimals: $decimals}';
  }
  factory SendTokenRequest.fromJson(Map<String, dynamic> json) => _$SendTokenRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SendTokenRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "SendTokenRequest";
}

