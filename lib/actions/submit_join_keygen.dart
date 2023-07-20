import 'package:mobileapp/models/action.dart';

class SubmitJoinKeygen extends Action {
  final String sharingSession;
  final String signerName;

  SubmitJoinKeygen(this.sharingSession, this.signerName);

  @override
  String toString() {
    return "[sharingSession=$sharingSession,signerName=$signerName]";
  }
}
