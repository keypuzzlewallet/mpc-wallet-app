import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_state.g.dart';

@CopyWith()
@JsonSerializable()
class UserState extends Equatable {
  String authForm;
  String? loginEmail;

  UserState({required this.authForm, this.loginEmail});

  factory UserState.fromJson(Map<String, dynamic> json) {
    return _$UserStateFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$UserStateToJson(this);

  @override
  List<Object?> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object?)
      .toList();
}
