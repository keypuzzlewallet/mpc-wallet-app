import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/models/wallet_entity.dart';

// a default wallet is loaded
class SelectDefaultWallet extends Action {
  final WalletEntity wallet;

  SelectDefaultWallet(this.wallet);

  @override
  String toString() {
    return "[WalletEntity=${wallet.name}]";
  }
}
