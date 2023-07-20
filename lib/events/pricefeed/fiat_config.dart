import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/fiat.dart';
part 'fiat_config.g.dart';
@JsonSerializable()
@CopyWith()
class FiatConfig extends Equatable implements Event, Action {
  final Fiat fiat; // fiat
  final String fiatName; // Fiat Name
  final String symbol; // Fiat symbol
  final String priceFeedId; // ID of price feed to use for this fiat
  final List<String> flags; // flags
  final bool enabled; // enabled

  FiatConfig ({required this.fiat, required this.fiatName, required this.symbol, required this.priceFeedId, required this.flags, required this.enabled});

  @override
  List<Object?> get props => [fiat, fiatName, symbol, priceFeedId, flags, enabled];

  @override
  String toString() {
    return 'FiatConfig{fiat: $fiat, fiatName: $fiatName, symbol: $symbol, priceFeedId: $priceFeedId, flags: $flags, enabled: $enabled}';
  }
  factory FiatConfig.fromJson(Map<String, dynamic> json) => _$FiatConfigFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FiatConfigToJson(this);
  @override
  String getName() => name();
  static String name() => "FiatConfig";
}

