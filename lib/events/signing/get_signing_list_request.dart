import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'get_signing_list_request.g.dart';
@JsonSerializable()
@CopyWith()
class GetSigningListRequest extends Equatable implements ClientRequestEvent, Action {
  final String walletId; // walletId

  GetSigningListRequest ({required this.walletId});

  @override
  List<Object?> get props => [walletId];

  @override
  String toString() {
    return 'GetSigningListRequest{walletId: $walletId}';
  }
  factory GetSigningListRequest.fromJson(Map<String, dynamic> json) => _$GetSigningListRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetSigningListRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "GetSigningListRequest";
}

