import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
part 'enabled_blockchain.g.dart';
@JsonSerializable()
@CopyWith()
class EnabledBlockchain extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final List<Coin> coins; // coins to enable for this blockchain

  EnabledBlockchain ({required this.blockchain, required this.coins});

  @override
  List<Object?> get props => [blockchain, coins];

  @override
  String toString() {
    return 'EnabledBlockchain{blockchain: $blockchain, coins: $coins}';
  }
  factory EnabledBlockchain.fromJson(Map<String, dynamic> json) => _$EnabledBlockchainFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EnabledBlockchainToJson(this);
  @override
  String getName() => name();
  static String name() => "EnabledBlockchain";
}

