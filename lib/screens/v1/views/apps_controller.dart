import 'package:flutx/flutx.dart';
import 'package:mobileapp/actions/controller_fetch_data.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/services/kbus.dart';

class AppsController extends FxController {
  AppsController();

  @override
  void initState() {
    super.initState();
    getIt<KbusClient>().fireE(this, ControllerLoaded(context, getTag()));
  }

  @override
  String getTag() {
    return "apps_controller";
  }
}
