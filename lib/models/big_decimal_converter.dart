import 'package:big_decimal/big_decimal.dart';
import 'package:json_annotation/json_annotation.dart';

class BigDecimalConverter extends JsonConverter<BigDecimal, dynamic> {
  @override
  BigDecimal fromJson(dynamic json) {
    if (json == null) {
      return BigDecimal.parse("0");
    }
    return BigDecimal.parse(json.toString());
  }

  @override
  dynamic toJson(BigDecimal object) {
    return object.toString();
  }

  const BigDecimalConverter();
}
