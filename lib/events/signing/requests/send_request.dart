import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';
part 'send_request.g.dart';
@JsonSerializable()
@CopyWith()
class SendRequest extends Equatable implements Event, Action {
  final String toAddress; // toAddress
  @BigDecimalConverter()
  final BigDecimal amount; // amount

  SendRequest ({required this.toAddress, required this.amount});

  @override
  List<Object?> get props => [toAddress, amount];

  @override
  String toString() {
    return 'SendRequest{toAddress: $toAddress, amount: $amount}';
  }
  factory SendRequest.fromJson(Map<String, dynamic> json) => _$SendRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SendRequestToJson(this);
  @override
  String getName() => name();
  static String name() => "SendRequest";
}

