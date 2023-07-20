import 'package:mobileapp/models/action.dart';

// trigger when a controller is loaded
class UpdateWhitelistedAddress extends Action {
  final bool value;

  UpdateWhitelistedAddress(this.value);

  @override
  String toString() {
    return "[value=$value]";
  }
}
