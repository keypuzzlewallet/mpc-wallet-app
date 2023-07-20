import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
part 'estimate_fee_request.g.dart';
@JsonSerializable()
@CopyWith()
class EstimateFeeRequest extends Equatable implements ClientRequestEvent, Action {
  final SigningRequest signingRequest; // signingRequest

  EstimateFeeRequest ({required this.signingRequest});

  @override
  List<Object?> get props => [signingRequest];

  @override
  String toString() {
    return 'EstimateFeeRequest{signingRequest: $signingRequest}';
  }
  factory EstimateFeeRequest.fromJson(Map<String, dynamic> json) => _$EstimateFeeRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EstimateFeeRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "EstimateFeeRequest";
}

