import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';

part 'address_list_item.g.dart';

@JsonSerializable()
class AddressListItem extends Equatable {
  final String name;
  final Blockchain blockchain;
  final Coin coin;
  final String address;
  final bool isWhiteListed;
  final DateTime createdAt;

  const AddressListItem(this.name, this.blockchain, this.coin, this.address,
      this.isWhiteListed, this.createdAt);

  factory AddressListItem.fromJson(Map<String, dynamic> json) =>
      _$AddressListItemFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddressListItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  List<Object> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object)
      .toList();
}
