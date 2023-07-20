import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
part 'send_raw_transaction_request.g.dart';
@JsonSerializable()
@CopyWith()
class SendRawTransactionRequest extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final String sessionId; // sessionId
  final String signedRawTransaction; // hex signed raw transaction to be sent
  final String fromAddress; // sender address

  SendRawTransactionRequest ({required this.blockchain, required this.coin, required this.sessionId, required this.signedRawTransaction, required this.fromAddress});

  @override
  List<Object?> get props => [blockchain, coin, sessionId, signedRawTransaction, fromAddress];

  @override
  String toString() {
    return 'SendRawTransactionRequest{blockchain: $blockchain, coin: $coin, sessionId: $sessionId, signedRawTransaction: $signedRawTransaction, fromAddress: $fromAddress}';
  }
  factory SendRawTransactionRequest.fromJson(Map<String, dynamic> json) => _$SendRawTransactionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SendRawTransactionRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "SendRawTransactionRequest";
}

