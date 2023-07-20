import 'package:big_decimal/big_decimal.dart';
import 'package:mobileapp/events/enums/blockchain.dart';
import 'package:mobileapp/events/enums/coin.dart';
import 'package:mobileapp/models/action.dart';
import 'package:mobileapp/models/big_decimal_converter.dart';

class SubmitNewSigningRequest extends Action {
  final Blockchain blockchain;
  final Coin coin;
  final String toAddress;
  @BigDecimalConverter()
  final BigDecimal amount;
  final String note;

  SubmitNewSigningRequest(
      this.blockchain, this.coin, this.toAddress, this.amount, this.note);

  @override
  String toString() {
    return "[blockchain=$blockchain,coin=$coin,toAddress=$toAddress,amount=$amount,note=$note]";
  }
}
