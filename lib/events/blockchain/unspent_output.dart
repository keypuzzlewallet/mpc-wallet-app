import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
part 'unspent_output.g.dart';
@JsonSerializable()
@CopyWith()
class UnspentOutput extends Equatable implements Event, Action {
  final String transactionHash; // transactionHash
  final int index; // index
  final String script; // script
  @BigDecimalConverter()
  final BigDecimal amount; // unspent amount

  UnspentOutput ({required this.transactionHash, required this.index, required this.script, required this.amount});

  @override
  List<Object?> get props => [transactionHash, index, script, amount];

  @override
  String toString() {
    return 'UnspentOutput{transactionHash: $transactionHash, index: $index, script: $script, amount: $amount}';
  }
  factory UnspentOutput.fromJson(Map<String, dynamic> json) => _$UnspentOutputFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UnspentOutputToJson(this);
  @override
  String getName() => name();
  static String name() => "UnspentOutput";
}

