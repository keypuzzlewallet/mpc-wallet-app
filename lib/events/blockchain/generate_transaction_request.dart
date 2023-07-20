import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
part 'generate_transaction_request.g.dart';
@JsonSerializable()
@CopyWith()
class GenerateTransactionRequest extends Equatable implements Event, Action {
  final String signingId; // signingId
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final SigningRequest signingRequest; // detail of signing request

  GenerateTransactionRequest ({required this.signingId, required this.blockchain, required this.coin, required this.signingRequest});

  @override
  List<Object?> get props => [signingId, blockchain, coin, signingRequest];

  @override
  String toString() {
    return 'GenerateTransactionRequest{signingId: $signingId, blockchain: $blockchain, coin: $coin, signingRequest: $signingRequest}';
  }
  factory GenerateTransactionRequest.fromJson(Map<String, dynamic> json) => _$GenerateTransactionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GenerateTransactionRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "GenerateTransactionRequest";
}

