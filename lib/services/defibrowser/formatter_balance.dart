
import 'package:big_decimal/big_decimal.dart';

/// Extension's [BigInt]
extension BigIntExt on BigInt {
  /// Format [BigInt] to string with [decimals] parameter
  String tokenString(int decimals) {
    BigDecimal value = BigDecimal.fromBigInt(this);
    BigDecimal decimalValue =
        value.divide(BigDecimal.fromBigInt(BigInt.from(10)).pow(decimals));
    return decimalValue.toString();
  }
}

/// Format gas price from hex to decimals. Output with 6 digit after comma
class FormatterBalance {
  /// Calculate gas price to send transaction
  static String configFeeValue({
    required String? beanValue,
    required String? offsetValue,
  }) {
    beanValue = beanValue?.replaceAll("null", "0");
    offsetValue = offsetValue?.replaceAll("null", "0");
    BigDecimal gasValue = BigDecimal.parse(beanValue ?? "0") *
        BigDecimal.fromBigInt(BigInt.from(10)).pow(9);
    gasValue = gasValue * BigDecimal.parse(offsetValue ?? "0");
    var feeValue =
        gasValue.divide(BigDecimal.fromBigInt(BigInt.from(10)).pow(18));
    return feeValue.toString();
  }
}
