import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileapp/models/address_list_item.dart';

class AddressListService {
  final FlutterSecureStorage _secureStorage;
  final String key = "address_list";
  final aOptions = const AndroidOptions(encryptedSharedPreferences: true);
  final iOptions =
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AddressListService(this._secureStorage);

  Future<List<AddressListItem>> findAll() async {
    String? value = await _secureStorage.read(
        key: key, iOptions: iOptions, aOptions: aOptions);
    if (value == null) {
      return [];
    }
    List<dynamic> json = jsonDecode(value);
    List<AddressListItem> result =
        json.map((e) => AddressListItem.fromJson(e)).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  Future<void> _update(List<AddressListItem> signingRequestEntitys) async {
    String value = jsonEncode(signingRequestEntitys);
    await _secureStorage.write(
        key: key, value: value, iOptions: iOptions, aOptions: aOptions);
  }

  Future<void> insert(AddressListItem item) async {
    List<AddressListItem> entities = await findAll();
    // replace an item or add
    int index = entities.indexWhere((element) =>
        element.blockchain == item.blockchain &&
        element.coin == item.coin &&
        element.address == item.address);
    if (index == -1) {
      entities.add(item);
    } else {
      entities[index] = item;
    }
    await _update(entities);
  }

  delete(AddressListItem event) async {
    List<AddressListItem> entities = await findAll();
    // replace an item or add
    int index = entities.indexWhere((element) =>
        element.blockchain == event.blockchain &&
        element.coin == event.coin &&
        element.address == event.address);
    if (index != -1) {
      entities.removeAt(index);
    }
    await _update(entities);
  }
}
