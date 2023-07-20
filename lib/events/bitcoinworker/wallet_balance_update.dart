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
part 'wallet_balance_update.g.dart';
@JsonSerializable()
@CopyWith()
class WalletBalanceUpdate extends Equatable implements Event, Action {
  final Blockchain blockchain; // blockchain
  final Coin coin; // coin
  @BigDecimalConverter()
  final BigDecimal balance; // wallet balance

  WalletBalanceUpdate ({required this.blockchain, required this.coin, required this.balance});

  @override
  List<Object?> get props => [blockchain, coin, balance];

  @override
  String toString() {
    return 'WalletBalanceUpdate{blockchain: $blockchain, coin: $coin, balance: $balance}';
  }
  factory WalletBalanceUpdate.fromJson(Map<String, dynamic> json) => _$WalletBalanceUpdateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WalletBalanceUpdateToJson(this);
  @override
  String getName() => name();
  static String name() => "WalletBalanceUpdate";
}

