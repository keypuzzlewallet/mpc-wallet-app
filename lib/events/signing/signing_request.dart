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
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/enums/request_transaction_type.dart';
import 'package:mobileapp/events/enums/signing_status.dart';
import 'package:mobileapp/events/signing/signing_result.dart';
import 'package:mobileapp/events/signing/requests/send_request.dart';
import 'package:mobileapp/events/signing/requests/send_token_request.dart';
import 'package:mobileapp/events/signing/requests/eth_contract_request.dart';
import 'package:mobileapp/events/enums/fee_level.dart';
part 'signing_request.g.dart';
@JsonSerializable()
@CopyWith()
class SigningRequest extends Equatable implements ClientRequestEvent, Action {
  final String id; // session id
  final String walletId; // walletId
  final Blockchain blockchain; // blockchain requesting for this transaction
  final Coin coin; // coin to send
  final KeyScheme keyScheme; // keyScheme
  final String pubkey; // pubkey public to sign. this is to verify after signing to ensure that signer is correct
  final String fromAddress; // address that is create and sign the transaction
  final int threshold; // threshold
  final RequestTransactionType requestTransactionType; // request transaction type
  final SigningStatus status; // signing status
  final String? message; // status message of this request e.g. error message
  final SigningResult? signingResult; // signingResult
  final SendRequest? sendRequest; // details of request for sending transaction type
  final SendTokenRequest? sendTokenRequest; // details of request for sending token transaction type
  final EthContractRequest? ethSmartContractRequest; // detail of a request from ethereum smart contract call
  final List<int> signers; // Party_id of signing members who are assigned to sign the transaction
  final FeeLevel feeLevel; // feeLevel
  @BigDecimalConverter()
  final BigDecimal? fee; // total amount needs to pay for the transaction
  final int version; // current version of the transaction request. Increase one every update. When update a signing request, if the version is old, it will be rejected
  final String createdAt; // time when the transaction request was created

  SigningRequest ({required this.id, required this.walletId, required this.blockchain, required this.coin, required this.keyScheme, required this.pubkey, required this.fromAddress, required this.threshold, required this.requestTransactionType, required this.status, this.message, this.signingResult, this.sendRequest, this.sendTokenRequest, this.ethSmartContractRequest, required this.signers, required this.feeLevel, this.fee, required this.version, required this.createdAt});

  @override
  List<Object?> get props => [id, walletId, blockchain, coin, keyScheme, pubkey, fromAddress, threshold, requestTransactionType, status, message, signingResult, sendRequest, sendTokenRequest, ethSmartContractRequest, signers, feeLevel, fee, version, createdAt];

  @override
  String toString() {
    return 'SigningRequest{id: $id, walletId: $walletId, blockchain: $blockchain, coin: $coin, keyScheme: $keyScheme, pubkey: $pubkey, fromAddress: $fromAddress, threshold: $threshold, requestTransactionType: $requestTransactionType, status: $status, message: $message, signingResult: $signingResult, sendRequest: $sendRequest, sendTokenRequest: $sendTokenRequest, ethSmartContractRequest: $ethSmartContractRequest, signers: $signers, feeLevel: $feeLevel, fee: $fee, version: $version, createdAt: $createdAt}';
  }
  factory SigningRequest.fromJson(Map<String, dynamic> json) => _$SigningRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SigningRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "SigningRequest";
}

