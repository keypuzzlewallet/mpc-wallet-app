import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';

part 'presignature_sharing.g.dart';

@JsonSerializable()
class PresignatureSharing extends Equatable {
  final String appVersion;
  final String address;
  final String walletId;
  final String roomId;
  final String requestId;
  final int nonceStartIndex;
  final int nonceSize;
  final KeyScheme keyScheme;

  PresignatureSharing(this.appVersion, this.address, this.walletId, this.roomId, this.requestId,
      this.nonceStartIndex, this.nonceSize, this.keyScheme);


  factory PresignatureSharing.fromJson(Map<String, dynamic> json) =>
      _$PresignatureSharingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PresignatureSharingToJson(this);

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
