import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'transaction_included.g.dart';
@JsonSerializable()
@CopyWith()
class TransactionIncluded extends Equatable implements Event, Action {
  final String signingSessionId; // signing session that created the transaction
  final String transactionId; // result transaction id after broadcasted

  TransactionIncluded ({required this.signingSessionId, required this.transactionId});

  @override
  List<Object?> get props => [signingSessionId, transactionId];

  @override
  String toString() {
    return 'TransactionIncluded{signingSessionId: $signingSessionId, transactionId: $transactionId}';
  }
  factory TransactionIncluded.fromJson(Map<String, dynamic> json) => _$TransactionIncludedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionIncludedToJson(this);
  @override
  String getName() => name();
  static String name() => "TransactionIncluded";
}

