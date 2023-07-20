import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'signature_recid_hex.g.dart';
@JsonSerializable()
@CopyWith()
class SignatureRecidHex extends Equatable implements Event, Action {
  final String r; // r
  final String s; // s
  final int recid; // recid

  SignatureRecidHex ({required this.r, required this.s, required this.recid});

  @override
  List<Object?> get props => [r, s, recid];

  @override
  String toString() {
    return 'SignatureRecidHex{r: $r, s: $s, recid: $recid}';
  }
  factory SignatureRecidHex.fromJson(Map<String, dynamic> json) => _$SignatureRecidHexFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SignatureRecidHexToJson(this);
  @override
  String getName() => name();
  static String name() => "SignatureRecidHex";
}

