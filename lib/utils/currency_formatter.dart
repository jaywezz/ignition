import 'package:intl/intl.dart';

final formatCurrency = new NumberFormat.currency(locale: "en_US", decimalDigits: 1,
    symbol: "");


int roundUpAbsolute(double number) {
  return number.isNegative ? number.floor() : number.ceil();
}