import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
part 'get_address_request.g.dart';
@JsonSerializable()
@CopyWith()
class GetAddressRequest extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  final WalletCreationConfig walletConfig; // config of created wallet

  GetAddressRequest ({required this.blockchain, required this.coin, required this.walletConfig});

  @override
  List<Object?> get props => [blockchain, coin, walletConfig];

  @override
  String toString() {
    return 'GetAddressRequest{blockchain: $blockchain, coin: $coin, walletConfig: $walletConfig}';
  }
  factory GetAddressRequest.fromJson(Map<String, dynamic> json) => _$GetAddressRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetAddressRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "GetAddressRequest";
}

