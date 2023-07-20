import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
part 'transaction_signed.g.dart';
@JsonSerializable()
@CopyWith()
class TransactionSigned extends Equatable implements Event, Action {
  final String signingId; // signingId
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final String signedTransaction; // signed transaction that is created from unsigned transaction and signatures
  final String transactionId; // unique transaction id for the signed transaction. In some other blockchains, it is also called transaction hash

  TransactionSigned ({required this.signingId, required this.blockchain, required this.coin, required this.signedTransaction, required this.transactionId});

  @override
  List<Object?> get props => [signingId, blockchain, coin, signedTransaction, transactionId];

  @override
  String toString() {
    return 'TransactionSigned{signingId: $signingId, blockchain: $blockchain, coin: $coin, signedTransaction: $signedTransaction, transactionId: $transactionId}';
  }
  factory TransactionSigned.fromJson(Map<String, dynamic> json) => _$TransactionSignedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionSignedToJson(this);
  @override
  String getName() => name();
  static String name() => "TransactionSigned";
}

