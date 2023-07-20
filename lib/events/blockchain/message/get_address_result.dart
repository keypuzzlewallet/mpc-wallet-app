import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'get_address_result.g.dart';
@JsonSerializable()
@CopyWith()
class GetAddressResult extends Equatable implements Event, Action {
  final String address; // address

  GetAddressResult ({required this.address});

  @override
  List<Object?> get props => [address];

  @override
  String toString() {
    return 'GetAddressResult{address: $address}';
  }
  factory GetAddressResult.fromJson(Map<String, dynamic> json) => _$GetAddressResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GetAddressResultToJson(this);
  @override
  String getName() => name();
  static String name() => "GetAddressResult";
}

