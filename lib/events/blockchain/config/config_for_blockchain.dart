import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
part 'config_for_blockchain.g.dart';
@JsonSerializable()
@CopyWith()
class ConfigForBlockchain extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final int decimals; // decimals
  final bool isNative; // whether the coin is native to the blockchain
  final String? contractAddress; // address of token contract to interact with
  final List<String> flags; // flags
  final bool enabled; // enabled

  ConfigForBlockchain ({required this.blockchain, required this.decimals, required this.isNative, this.contractAddress, required this.flags, required this.enabled});

  @override
  List<Object?> get props => [blockchain, decimals, isNative, contractAddress, flags, enabled];

  @override
  String toString() {
    return 'ConfigForBlockchain{blockchain: $blockchain, decimals: $decimals, isNative: $isNative, contractAddress: $contractAddress, flags: $flags, enabled: $enabled}';
  }
  factory ConfigForBlockchain.fromJson(Map<String, dynamic> json) => _$ConfigForBlockchainFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConfigForBlockchainToJson(this);
  @override
  String getName() => name();
  static String name() => "ConfigForBlockchain";
}

