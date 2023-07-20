import 'package:network_info_plus/network_info_plus.dart';

class NetworkService {
  final networkInfo = NetworkInfo();

  Future<String?> getLocalIp() async {
    return await networkInfo.getWifiIP();
  }
}
