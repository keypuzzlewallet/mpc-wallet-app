import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/signing/signature_recid_hex.dart';
part 'sign_transaction_request.g.dart';
@JsonSerializable()
@CopyWith()
class SignTransactionRequest extends Equatable implements Event, Action {
  final String signingId; // signingId
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final String unsignedTransaction; // raw/unsigned transaction that is requested to be signed
  final String pubkey; // wallet pubkey that is signing this transaction
  final List<String> hashes; // hash string form raw transaction that are signing
  final List<SignatureRecidHex> signatures; // signature for each signing hash in hashes array

  SignTransactionRequest ({required this.signingId, required this.blockchain, required this.coin, required this.unsignedTransaction, required this.pubkey, required this.hashes, required this.signatures});

  @override
  List<Object?> get props => [signingId, blockchain, coin, unsignedTransaction, pubkey, hashes, signatures];

  @override
  String toString() {
    return 'SignTransactionRequest{signingId: $signingId, blockchain: $blockchain, coin: $coin, unsignedTransaction: $unsignedTransaction, pubkey: $pubkey, hashes: $hashes, signatures: $signatures}';
  }
  factory SignTransactionRequest.fromJson(Map<String, dynamic> json) => _$SignTransactionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignTransactionRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "SignTransactionRequest";
}

