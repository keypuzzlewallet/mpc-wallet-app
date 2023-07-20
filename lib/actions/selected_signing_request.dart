import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/models/wallet_entity.dart';

class SelectedSigningRequest extends Action {
  final SigningRequest session;
  final WalletEntity signingWallet;

  SelectedSigningRequest(this.session, this.signingWallet);

  @override
  String toString() {
    return "[session=$session,signingWallet=$signingWallet]";
  }
}
