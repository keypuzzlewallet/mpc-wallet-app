import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/states/key_generation_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/signing_state.dart';
import 'package:mobileapp/states/user_state.dart';
import 'package:mobileapp/states/wallets_state.dart';

part 'app_global_state.g.dart';

@CopyWith()
@JsonSerializable()
class AppGlobalState extends Equatable {
  SettingsState settingsState;
  KeyGenerationState keyGenerationState;
  SigningState signingState;
  WalletsState walletsState;
  UserState userState;

  AppGlobalState({
    required this.settingsState,
    required this.keyGenerationState,
    required this.signingState,
    required this.walletsState,
    required this.userState,
  });

  factory AppGlobalState.fromJson(Map<String, dynamic> json) =>
      _$AppGlobalStateFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppGlobalStateToJson(this);

  @override
  List<Object?> get props => toJson()
      .values
      .where((element) => element != null)
      .map((e) => e as Object?)
      .toList();
}
