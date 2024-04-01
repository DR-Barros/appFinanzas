import 'package:intl/intl.dart';

/*
* Model class for Transaction
*/
class Transaction {
  final String id;
  final String title;
  final int amount;
  final DateTime date;
  final int toAccountID;
  final String type;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.toAccountID,
    this.type = 'income',
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      toAccountID: json['toAccountID'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'toAccountID': toAccountID,
      'type': type,
    };
  }

  String getAmountString() {
    final formatter = NumberFormat('#,##0', 'es_AR');
    return formatter.format(amount);
  }
}
