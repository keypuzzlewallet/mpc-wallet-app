import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
part 'verify_transaction_request.g.dart';
@JsonSerializable()
@CopyWith()
class VerifyTransactionRequest extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final String rawTransaction; // transaction that user will sign. we need to verify it against sigingRequest before signing
  final SigningRequest signingRequest; // this object is visible to user. we need to make sure rawTransaction is signed according to this object

  VerifyTransactionRequest ({required this.blockchain, required this.coin, required this.rawTransaction, required this.signingRequest});

  @override
  List<Object?> get props => [blockchain, coin, rawTransaction, signingRequest];

  @override
  String toString() {
    return 'VerifyTransactionRequest{blockchain: $blockchain, coin: $coin, rawTransaction: $rawTransaction, signingRequest: $signingRequest}';
  }
  factory VerifyTransactionRequest.fromJson(Map<String, dynamic> json) => _$VerifyTransactionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VerifyTransactionRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "VerifyTransactionRequest";
}

