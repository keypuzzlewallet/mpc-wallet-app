import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
part 'hot_signing_request.g.dart';
@JsonSerializable()
@CopyWith()
class HotSigningRequest extends Equatable implements Event, Action {
  final SigningRequest signingRequest; // signingRequest

  HotSigningRequest ({required this.signingRequest});

  @override
  List<Object?> get props => [signingRequest];

  @override
  String toString() {
    return 'HotSigningRequest{signingRequest: $signingRequest}';
  }
  factory HotSigningRequest.fromJson(Map<String, dynamic> json) => _$HotSigningRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HotSigningRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "HotSigningRequest";
}

