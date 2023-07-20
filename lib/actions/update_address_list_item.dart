import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/models/address_list_item.dart';

// a default wallet is loaded
class UpdateAddressListItem extends Action {
  final AddressListItem item;

  UpdateAddressListItem(this.item);

  @override
  String toString() {
    return "[item=$item]";
  }
}
