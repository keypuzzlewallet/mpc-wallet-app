import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/wallet/enabled_blockchain.dart';
import 'package:mobileapp/events/wallet/wallet_creation_config.dart';
part 'client_wallet_loaded.g.dart';
@JsonSerializable()
@CopyWith()
class ClientWalletLoaded extends Equatable implements ClientRequestEvent, Action {
  final List<EnabledBlockchain> enabledBlockchains; // blockchains enabled for wallet
  final WalletCreationConfig walletConfig; // config of created wallet

  ClientWalletLoaded ({required this.enabledBlockchains, required this.walletConfig});

  @override
  List<Object?> get props => [enabledBlockchains, walletConfig];

  @override
  String toString() {
    return 'ClientWalletLoaded{enabledBlockchains: $enabledBlockchains, walletConfig: $walletConfig}';
  }
  factory ClientWalletLoaded.fromJson(Map<String, dynamic> json) => _$ClientWalletLoadedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ClientWalletLoadedToJson(this);
  @override
  String getName() => name();
  static String name() => "ClientWalletLoaded";
}

