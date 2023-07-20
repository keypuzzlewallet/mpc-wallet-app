import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/models/action.dart';

class SubmitJoinSigning extends Action {
  final SigningRequest signingRequest;

  SubmitJoinSigning(this.signingRequest);

  @override
  String toString() {
    return "[signingRequest=$signingRequest]";
  }
}
