import 'package:intl/intl.dart';

String moneyFormatter(int amount) {
  return NumberFormat.currency(
    locale: 'es_CL',
    symbol: '\$',
    decimalDigits: 0,
  ).format(amount);
}
