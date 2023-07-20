import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/signing/signing_hash.dart';
part 'signing_result.g.dart';
@JsonSerializable()
@CopyWith()
class SigningResult extends Equatable implements Event, Action {
  final List<SigningHash> signingHashes; // signingHashes
  final String unsignedTransaction; // hex transaction to be signed. We could use this to verify details in the request.
  final String? transactionHash; // transaction id/hash which could be obtained after signing or submit in some blockchains
  final String? signedTransaction; // hex signedTransaction to be sent

  SigningResult ({required this.signingHashes, required this.unsignedTransaction, this.transactionHash, this.signedTransaction});

  @override
  List<Object?> get props => [signingHashes, unsignedTransaction, transactionHash, signedTransaction];

  @override
  String toString() {
    return 'SigningResult{signingHashes: $signingHashes, unsignedTransaction: $unsignedTransaction, transactionHash: $transactionHash, signedTransaction: $signedTransaction}';
  }
  factory SigningResult.fromJson(Map<String, dynamic> json) => _$SigningResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SigningResultToJson(this);
  @override
  String getName() => name();
  static String name() => "SigningResult";
}

