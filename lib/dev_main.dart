import 'package:mobileapp/main.dart';
import 'package:mobileapp/models/app_config.dart';
import 'package:mobileapp/models/app_env.dart';

main() async {
  runMain(const AppConfig(
      backendHost: "http://192.168.0.136:8080",
      keygenEndpoint: "http://192.168.0.136:8000",
      firebaseTestEndpoint: "192.168.0.136",
      isSegwit: true,
      isMainnet: false,
      appEnv: AppEnv.DEV));
}
