import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/events/pricefeed/coin_price.dart';
import 'package:mobileapp/events/pricefeed/coin_prices.dart';
import 'package:mobileapp/models/data/coin_data.dart';
import 'package:mobileapp/models/wallet_entity.dart';

part 'wallets_state.g.dart';

@CopyWith()
@JsonSerializable()
class WalletsState extends Equatable {
  List<WalletEntity>? wallets;
  WalletEntity? defaultWallet;
  List<CoinData>? coins;
  List<CoinPrice>? prices;

  WalletsState({this.wallets, this.defaultWallet, this.coins, this.prices});

  factory WalletsState.fromJson(Map<String, dynamic> json) =>
      _$WalletsStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WalletsStateToJson(this);

  @override
  List<Object?> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object?)
      .toList();
}
