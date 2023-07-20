import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
part 'generate_transaction_error.g.dart';
@JsonSerializable()
@CopyWith()
class GenerateTransactionError extends Equatable implements Event, Action {
  final String signingId; // signingId
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final String error; // reason why transaction failed to be created

  GenerateTransactionError ({required this.signingId, required this.blockchain, required this.coin, required this.error});

  @override
  List<Object?> get props => [signingId, blockchain, coin, error];

  @override
  String toString() {
    return 'GenerateTransactionError{signingId: $signingId, blockchain: $blockchain, coin: $coin, error: $error}';
  }
  factory GenerateTransactionError.fromJson(Map<String, dynamic> json) => _$GenerateTransactionErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GenerateTransactionErrorToJson(this);
  @override
  String getName() => name();
  static String name() => "GenerateTransactionError";
}

