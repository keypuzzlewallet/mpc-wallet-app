import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
part 'blockchain_config.g.dart';
@JsonSerializable()
@CopyWith()
class BlockchainConfig extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final KeyScheme keyScheme; // keyScheme
  final String blockchainName; // Blockchain Name
  final List<String> flags; // flags
  final String? chainId; // chainId
  final String? rpc; // public rpc
  final String txExplorer; // explorer to view transaction status
  final String addressExplorer; // explorer to view address balance
  final bool enabled; // enabled

  BlockchainConfig ({required this.blockchain, required this.keyScheme, required this.blockchainName, required this.flags, this.chainId, this.rpc, required this.txExplorer, required this.addressExplorer, required this.enabled});

  @override
  List<Object?> get props => [blockchain, keyScheme, blockchainName, flags, chainId, rpc, txExplorer, addressExplorer, enabled];

  @override
  String toString() {
    return 'BlockchainConfig{blockchain: $blockchain, keyScheme: $keyScheme, blockchainName: $blockchainName, flags: $flags, chainId: $chainId, rpc: $rpc, txExplorer: $txExplorer, addressExplorer: $addressExplorer, enabled: $enabled}';
  }
  factory BlockchainConfig.fromJson(Map<String, dynamic> json) => _$BlockchainConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BlockchainConfigToJson(this);
  @override
  String getName() => name();
  static String name() => "BlockchainConfig";
}

