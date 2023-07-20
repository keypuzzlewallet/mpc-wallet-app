import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/enums/keygen_status.dart';
import 'package:mobileapp/states/key_generation_mode.dart';

part 'key_generation_state.g.dart';

@CopyWith()
@JsonSerializable()
class KeyGenerationState extends Equatable {
  KeyGenerationMode? mode;
  String? serverEndpoint;
  String? keygenId;
  String? walletId;
  String? currentKeygenWalletName;
  String? currentKeygenSignerName;
  int? numberOfMembers;
  int? numberOfRequiredSignatures;
  KeygenStatus? status;
  KeyScheme? generateNonceKeySchema;
  int? numberOfNonceToGenerate;
  int? nonceStartIndex;
  String? requestId;


  KeyGenerationState({
    this.mode,
    this.serverEndpoint,
    this.keygenId,
    this.walletId,
    this.currentKeygenWalletName,
    this.currentKeygenSignerName,
    this.numberOfMembers,
    this.numberOfRequiredSignatures,
    this.status,
    this.generateNonceKeySchema,
    this.numberOfNonceToGenerate,
    this.requestId,
    this.nonceStartIndex,
  });

  factory KeyGenerationState.fromJson(Map<String, dynamic> json) =>
      _$KeyGenerationStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KeyGenerationStateToJson(this);

  @override
  List<Object?> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object?)
      .toList();
}
