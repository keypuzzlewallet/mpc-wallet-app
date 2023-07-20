import 'package:mobileapp/models/app_env.dart';

class AppConfig {
  final String backendHost;
  final String keygenEndpoint;
  final String? firebaseTestEndpoint;
  final bool isMainnet;
  final bool isSegwit;
  final AppEnv appEnv;

  const AppConfig(
      {required this.backendHost,
      required this.keygenEndpoint,
      this.firebaseTestEndpoint,
      required this.isMainnet,
      required this.isSegwit,
      required this.appEnv});
}
