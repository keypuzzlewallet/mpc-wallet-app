import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
part 'create_transaction_result.g.dart';
@JsonSerializable()
@CopyWith()
class CreateTransactionResult extends Equatable implements Event, Action {
  final String rawTransaction; // created raw transaction from the request
  @BigDecimalConverter()
  final BigDecimal fee; // total amount needs to pay for the transaction
  final List<String> hashes; // hashes of the created raw transaction

  CreateTransactionResult ({required this.rawTransaction, required this.fee, required this.hashes});

  @override
  List<Object?> get props => [rawTransaction, fee, hashes];

  @override
  String toString() {
    return 'CreateTransactionResult{rawTransaction: $rawTransaction, fee: $fee, hashes: $hashes}';
  }
  factory CreateTransactionResult.fromJson(Map<String, dynamic> json) => _$CreateTransactionResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateTransactionResultToJson(this);
  @override
  String getName() => name();
  static String name() => "CreateTransactionResult";
}

