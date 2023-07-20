import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/models/address_list_item.dart';

class DeleteAddressListItem extends Action {
  final AddressListItem deleting;

  DeleteAddressListItem(this.deleting);

  @override
  String toString() {
    return "[deleting=$deleting]";
  }
}
