import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
part 'get_signing_list_result.g.dart';
@JsonSerializable()
@CopyWith()
class GetSigningListResult extends Equatable implements Event, Action {
  final List<SigningRequest> signings; // signings

  GetSigningListResult ({required this.signings});

  @override
  List<Object?> get props => [signings];

  @override
  String toString() {
    return 'GetSigningListResult{signings: $signings}';
  }
  factory GetSigningListResult.fromJson(Map<String, dynamic> json) => _$GetSigningListResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetSigningListResultToJson(this);
  @override
  String getName() => name();
  static String name() => "GetSigningListResult";
}

