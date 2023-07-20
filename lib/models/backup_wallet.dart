import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/wallet_entity.dart';

part 'backup_wallet.g.dart';

@JsonSerializable()
@CopyWith()
class BackupWallet extends Equatable {
  final WalletEntity walletEntity;
  final String secret;

  const BackupWallet({required this.walletEntity, required this.secret});

  factory BackupWallet.fromJson(Map<String, dynamic> json) =>
      _$BackupWalletFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BackupWalletToJson(this);

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
