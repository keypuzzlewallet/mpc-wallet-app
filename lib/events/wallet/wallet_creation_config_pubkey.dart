import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
part 'wallet_creation_config_pubkey.g.dart';
@JsonSerializable()
@CopyWith()
class WalletCreationConfigPubkey extends Equatable implements Event, Action {
  final String pubkey; // wallet public key for given signature scheme
  final KeyScheme keyScheme; // keyScheme

  WalletCreationConfigPubkey ({required this.pubkey, required this.keyScheme});

  @override
  List<Object?> get props => [pubkey, keyScheme];

  @override
  String toString() {
    return 'WalletCreationConfigPubkey{pubkey: $pubkey, keyScheme: $keyScheme}';
  }
  factory WalletCreationConfigPubkey.fromJson(Map<String, dynamic> json) => _$WalletCreationConfigPubkeyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WalletCreationConfigPubkeyToJson(this);
  @override
  String getName() => name();
  static String name() => "WalletCreationConfigPubkey";
}

