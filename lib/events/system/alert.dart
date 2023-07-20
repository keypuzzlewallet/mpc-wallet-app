import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/enums/alert_level.dart';
part 'alert.g.dart';
@JsonSerializable()
@CopyWith()
class Alert extends Equatable implements Event, Action {
  final AlertLevel level; // level
  final String message; // message
  final int? code; // alert code which reflect http status code

  Alert ({required this.level, required this.message, this.code});

  @override
  List<Object?> get props => [level, message, code];

  @override
  String toString() {
    return 'Alert{level: $level, message: $message, code: $code}';
  }
  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AlertToJson(this);
  @override
  String getName() => name();
  static String name() => "Alert";
}

