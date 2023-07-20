import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobileapp/models/event.dart';
import 'package:mobileapp/models/client_request_event.dart';
import 'package:mobileapp/models/action.dart';
import 'package:equatable/equatable.dart';
import 'package:mobileapp/events/signing/signing_state_base64.dart';
part 'signing_hash.g.dart';
@JsonSerializable()
@CopyWith()
class SigningHash extends Equatable implements Event, Action {
  final SigningStateBase64? state; // signing state that contains part signed from parties. If all required part signed are included, it will generate signature
  final int nonce; // private key nonce to sign this hash
  final String hash; // hash to sign

  SigningHash ({this.state, required this.nonce, required this.hash});

  @override
  List<Object?> get props => [state, nonce, hash];

  @override
  String toString() {
    return 'SigningHash{state: $state, nonce: $nonce, hash: $hash}';
  }
  factory SigningHash.fromJson(Map<String, dynamic> json) => _$SigningHashFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SigningHashToJson(this);
  @override
  String getName() => name();
  static String name() => "SigningHash";
}

