import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/keygenv2/encrypted_local_key.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
part 'encrypted_keygen_with_scheme.g.dart';
@JsonSerializable()
@CopyWith()
class EncryptedKeygenWithScheme extends Equatable implements Event, Action {
  final EncryptedLocalKey encryptedLocalKey; // encryptedLocalKey
  final int nonceStartIndex; // nonce start index
  final int nonceSize; // number of nonces generated
  final KeyScheme keyScheme; // keyScheme

  EncryptedKeygenWithScheme ({required this.encryptedLocalKey, required this.nonceStartIndex, required this.nonceSize, required this.keyScheme});

  @override
  List<Object?> get props => [encryptedLocalKey, nonceStartIndex, nonceSize, keyScheme];

  @override
  String toString() {
    return 'EncryptedKeygenWithScheme{encryptedLocalKey: $encryptedLocalKey, nonceStartIndex: $nonceStartIndex, nonceSize: $nonceSize, keyScheme: $keyScheme}';
  }
  factory EncryptedKeygenWithScheme.fromJson(Map<String, dynamic> json) => _$EncryptedKeygenWithSchemeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EncryptedKeygenWithSchemeToJson(this);
  @override
  String getName() => name();
  static String name() => "EncryptedKeygenWithScheme";
}

