import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/signing/signature_recid_hex.dart';
part 'create_sign_transaction_request.g.dart';
@JsonSerializable()
@CopyWith()
class CreateSignTransactionRequest extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final String pubkey; // signer ecopint which will be used to verify if signature is valid
  final String rawTransaction; // raw transaction that is used to decoded and sign
  final List<String> hashes; // hashes of the transaction
  final List<SignatureRecidHex> signatures; // signatures of the transaction

  CreateSignTransactionRequest ({required this.blockchain, required this.coin, required this.pubkey, required this.rawTransaction, required this.hashes, required this.signatures});

  @override
  List<Object?> get props => [blockchain, coin, pubkey, rawTransaction, hashes, signatures];

  @override
  String toString() {
    return 'CreateSignTransactionRequest{blockchain: $blockchain, coin: $coin, pubkey: $pubkey, rawTransaction: $rawTransaction, hashes: $hashes, signatures: $signatures}';
  }
  factory CreateSignTransactionRequest.fromJson(Map<String, dynamic> json) => _$CreateSignTransactionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateSignTransactionRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "CreateSignTransactionRequest";
}

