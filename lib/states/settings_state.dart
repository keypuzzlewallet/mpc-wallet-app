import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/address_list_item.dart';

part 'settings_state.g.dart';

@CopyWith()
@JsonSerializable()
class SettingsState extends Equatable {
  bool isHotWallet;
  bool whitelisted;
  bool connected;
  List<AddressListItem>? addressList;

  SettingsState(
      {required this.isHotWallet, required this.whitelisted, this.addressList, required this.connected});

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    if (json["connected"] == null) {
      json["connected"] = false;
    }
    return _$SettingsStateFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);

  @override
  List<Object?> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object?)
      .toList();
}
