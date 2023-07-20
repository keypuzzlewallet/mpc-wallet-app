import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_btc.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_eth_legacy.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_eth_eip1559.dart';
import 'package:mobileapp/events/blockchain/message/params/request_params_ada.dart';
part 'create_transaction_request.g.dart';
@JsonSerializable()
@CopyWith()
class CreateTransactionRequest extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final SigningRequest signingRequest; // details of the transaction to be signed which created by user
  final RequestParamsBtc? requestParamsBtc; // parameters required for signing UTXO chains like BTC
  final RequestParamsEthLegacy? requestParamsEthLegacy; // parameters required for signing EVM chains like ETH POLYGON
  final RequestParamsEthEip1559? requestParamsEthEip1559; // parameters required for signing EVM chains like ETH POLYGON using EIP1559 gas model
  final RequestParamsAda? requestParamsAda; // parameters required for signing Cardano chains

  CreateTransactionRequest ({required this.blockchain, required this.coin, required this.signingRequest, this.requestParamsBtc, this.requestParamsEthLegacy, this.requestParamsEthEip1559, this.requestParamsAda});

  @override
  List<Object?> get props => [blockchain, coin, signingRequest, requestParamsBtc, requestParamsEthLegacy, requestParamsEthEip1559, requestParamsAda];

  @override
  String toString() {
    return 'CreateTransactionRequest{blockchain: $blockchain, coin: $coin, signingRequest: $signingRequest, requestParamsBtc: $requestParamsBtc, requestParamsEthLegacy: $requestParamsEthLegacy, requestParamsEthEip1559: $requestParamsEthEip1559, requestParamsAda: $requestParamsAda}';
  }
  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) => _$CreateTransactionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateTransactionRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "CreateTransactionRequest";
}

