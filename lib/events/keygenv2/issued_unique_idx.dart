import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
part 'issued_unique_idx.g.dart';
@JsonSerializable()
@CopyWith()
class IssuedUniqueIdx extends Equatable implements Event, Action {
  final int unique_idx; // unique_idx

  IssuedUniqueIdx ({required this.unique_idx});

  @override
  List<Object?> get props => [unique_idx];

  @override
  String toString() {
    return 'IssuedUniqueIdx{unique_idx: $unique_idx}';
  }
  factory IssuedUniqueIdx.fromJson(Map<String, dynamic> json) => _$IssuedUniqueIdxFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IssuedUniqueIdxToJson(this);
  @override
  String getName() => name();
  static String name() => "IssuedUniqueIdx";
}

