import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_result.dart';
import 'package:mobileapp/events/signing/signing_request.dart';

part 'signing_state.g.dart';

@CopyWith()
@JsonSerializable()
class SigningState extends Equatable {
  SigningRequest? currentSigningRequest;
  List<SigningRequest>? signingSessions;
  EstimateFeeResult? estimatedFee;

  SigningState({this.currentSigningRequest, this.signingSessions, this.estimatedFee});

  factory SigningState.fromJson(Map<String, dynamic> json) =>
      _$SigningStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SigningStateToJson(this);

  @override
  List<Object?> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object?)
      .toList();
}
