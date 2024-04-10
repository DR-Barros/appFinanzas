import 'package:intl/intl.dart';

/*
* Model class for Transaction
*/
class Transaction {
  final int id;
  final String title;
  final int amount;
  final DateTime date;
  final int fromAccountID;
  final int toAccountID;
  String type;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.toAccountID,
    required this.fromAccountID,
    this.type = 'income',
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      toAccountID: json['toAccountID'],
      fromAccountID: json['fromAccountID'],
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
      'fromAccountID': fromAccountID,
      'type': type,
    };
  }

  void updateType(String type) {
    this.type = type;
  }
}
