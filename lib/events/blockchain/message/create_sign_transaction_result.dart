import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'create_sign_transaction_result.g.dart';
@JsonSerializable()
@CopyWith()
class CreateSignTransactionResult extends Equatable implements Event, Action {
  final String signedTransaction; // signed transaction which is ready to send to the network
  final String transactionHash; // hash of the transaction

  CreateSignTransactionResult ({required this.signedTransaction, required this.transactionHash});

  @override
  List<Object?> get props => [signedTransaction, transactionHash];

  @override
  String toString() {
    return 'CreateSignTransactionResult{signedTransaction: $signedTransaction, transactionHash: $transactionHash}';
  }
  factory CreateSignTransactionResult.fromJson(Map<String, dynamic> json) => _$CreateSignTransactionResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateSignTransactionResultToJson(this);
  @override
  String getName() => name();
  static String name() => "CreateSignTransactionResult";
}

