import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'keygen_sharing.g.dart';

@JsonSerializable()
class KeygenSharing extends Equatable {
  final String appVersion;
  final String serverEndpoint;
  final String keygenId;
  final String currentKeygenWalletName;
  final int numberOfMembers;
  final int numberOfRequiredSignatures;

  KeygenSharing(
      this.appVersion,
      this.serverEndpoint,
      this.keygenId,
      this.currentKeygenWalletName,
      this.numberOfMembers,
      this.numberOfRequiredSignatures);

  factory KeygenSharing.fromJson(Map<String, dynamic> json) =>
      _$KeygenSharingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KeygenSharingToJson(this);

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
