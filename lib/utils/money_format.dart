import 'package:intl/intl.dart';

/// formatea un monto en un string con el formato de moneda
/// por ejemplo 1000 -> $1.000
String moneyFormatter(int amount) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
  return formatter.format(amount);
  
}
