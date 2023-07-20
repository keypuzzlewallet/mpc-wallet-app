import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'verify_transaction_result.g.dart';
@JsonSerializable()
@CopyWith()
class VerifyTransactionResult extends Equatable implements Event, Action {
  final String? failedReason; // reason why verification failed. If verification succeeded, this field is empty

  VerifyTransactionResult ({this.failedReason});

  @override
  List<Object?> get props => [failedReason];

  @override
  String toString() {
    return 'VerifyTransactionResult{failedReason: $failedReason}';
  }
  factory VerifyTransactionResult.fromJson(Map<String, dynamic> json) => _$VerifyTransactionResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VerifyTransactionResultToJson(this);
  @override
  String getName() => name();
  static String name() => "VerifyTransactionResult";
}

