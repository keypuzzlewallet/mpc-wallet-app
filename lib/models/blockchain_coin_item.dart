import 'package:mobileapp/events/blockchain/config/blockchain_coin_config.dart';
import 'package:mobileapp/events/blockchain/config/blockchain_config.dart';

class BlockchainCoinItem {
  final BlockchainConfig blockchainConfig;
  final BlockchainCoinConfig coinConfig;

  BlockchainCoinItem(this.blockchainConfig, this.coinConfig);

  @override
  String toString() {
    return '${blockchainConfig.blockchainName} ${coinConfig.coinName}';
  }
}
