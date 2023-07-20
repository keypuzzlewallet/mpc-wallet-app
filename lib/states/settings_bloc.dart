import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/actions/delete_address_list_item.dart';
import 'package:mobileapp/actions/update_address_list_item.dart';
import 'package:mobileapp/actions/update_connection_status.dart';
import 'package:mobileapp/actions/update_hot_wallet.dart';
import 'package:mobileapp/actions/update_whitelisted_addresses.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/services/address_list_service.dart';
import 'package:mobileapp/services/kbus.dart';
import 'package:mobileapp/services/sse_service.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/sub_bloc.dart';

class SettingsBloc extends SubBloc {
  final KbusClient kbus;

  SettingsBloc(super.getState, super.emit, super.setContext, super.getContext, this.kbus) {
    kbus
        .onE<UpdateHotWallet>(this)
        .listen((event) => _handleUpdateHotWallet(event));
    kbus
        .onE<ControllerLoaded>(this)
        .listen((event) => _handleControllerLoaded(event));
    kbus
        .onE<UpdateAddressListItem>(this)
        .listen((event) => _handleUpdateAddressListItem(event));
    kbus
        .onE<DeleteAddressListItem>(this)
        .listen((event) => _handleDeleteAddressListItem(event));
    kbus
        .onE<UpdateWhitelistedAddress>(this)
        .listen((event) => _handleUpdateWhitelistedAddress(event));
    kbus
        .onE<UpdateConnectionStatus>(this)
        .listen((event) => _handleUpdateConnectionStatus(event));
  }

  _handleUpdateHotWallet(UpdateHotWallet event) async {
    getIt<SseService>().isHotWallet = event.hotWallet;
    if (event.hotWallet) {
      await getIt<SseService>().establishConnectionAndWait();
    } else {
      await getIt<SseService>().closeConnection();
    }
    emit(getState().copyWith(
        settingsState:
            getState().settingsState.copyWith(isHotWallet: event.hotWallet)));
  }

  _handleUpdateWhitelistedAddress(UpdateWhitelistedAddress event) {
    emit(getState().copyWith(
        settingsState:
            getState().settingsState.copyWith(whitelisted: event.value)));
  }

  _handleUpdateAddressListItem(UpdateAddressListItem event) async {
    await getIt<AddressListService>().insert(event.item);
    emit(getState().copyWith(
        settingsState: getState().settingsState.copyWith(
            addressList: await getIt<AddressListService>().findAll())));
  }

  _handleControllerLoaded(ControllerLoaded event) async {
    if (event.controllerTag == "address_list_controller") {
      emit(getState().copyWith(
          settingsState: getState().settingsState.copyWith(
              addressList: await getIt<AddressListService>().findAll())));
    }
  }

  _handleDeleteAddressListItem(DeleteAddressListItem event) async {
    await getIt<AddressListService>().delete(event.deleting);
    emit(getState().copyWith(
        settingsState: getState().settingsState.copyWith(
            addressList: await getIt<AddressListService>().findAll())));
  }

  _handleUpdateConnectionStatus(UpdateConnectionStatus event) {
    emit(getState().copyWith(
        settingsState:
            getState().settingsState.copyWith(connected: event.connected)));
  }
}
