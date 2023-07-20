import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
part 'generate_transaction_response.g.dart';
@JsonSerializable()
@CopyWith()
class GenerateTransactionResponse extends Equatable implements Event, Action {
  final String signingId; // signingId
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final String rawTx; // created unsigned transaction
  @BigDecimalConverter()
  final BigDecimal fee; // estimated transaction fee
  final List<String> hashes; // list of hashes that required user to sign. If there are multiple hashes, the order is the same as inputs in the request

  GenerateTransactionResponse ({required this.signingId, required this.blockchain, required this.coin, required this.rawTx, required this.fee, required this.hashes});

  @override
  List<Object?> get props => [signingId, blockchain, coin, rawTx, fee, hashes];

  @override
  String toString() {
    return 'GenerateTransactionResponse{signingId: $signingId, blockchain: $blockchain, coin: $coin, rawTx: $rawTx, fee: $fee, hashes: $hashes}';
  }
  factory GenerateTransactionResponse.fromJson(Map<String, dynamic> json) => _$GenerateTransactionResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GenerateTransactionResponseToJson(this);
  @override
  String getName() => name();
  static String name() => "GenerateTransactionResponse";
}

