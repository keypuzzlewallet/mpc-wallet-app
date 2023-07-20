import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/models/wallet_entity.dart';

class SubmitNewNonce extends Action {
  final WalletEntity wallet;
  final KeyScheme keyScheme;

  SubmitNewNonce(this.wallet, this.keyScheme);

  @override
  String toString() {
    return "[wallet=${wallet.name},keyScheme=${keyScheme.name}]";
  }
}
