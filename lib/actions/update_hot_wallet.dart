import 'package:mobileapp/models/action.dart';

// trigger when a controller is loaded
class UpdateHotWallet extends Action {
  final bool hotWallet;

  UpdateHotWallet(this.hotWallet);

  @override
  String toString() {
    return "[hotWallet=$hotWallet]";
  }
}
