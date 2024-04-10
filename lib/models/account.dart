import 'package:app_finanzas/models/transaction.dart';
import 'package:intl/intl.dart';

/*
  This class is used to store the bank account information of the user.
*/
class Account {
  final int id;
  final String name;
  final String type;

  Account({
    required this.id,
    required this.name,
    this.type = 'current',
  }) {}

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  int getBalance(List<Transaction> transactions) {
    int balance = 0;
    for (Transaction transaction in transactions) {
      if (transaction.toAccountID == id) {
        balance += transaction.amount;
      } else if (transaction.fromAccountID == id) {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  int getTotalTransactionsByMonth(
      DateTime date, List<Transaction> transactions) {
    int total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.date.year == date.year &&
          transaction.date.month == date.month) {
        total += transaction.amount;
      }
    }
    return total;
  }

  int getTotalTransactionsByMonthAndType(
      DateTime date, String type, List<Transaction> transactions) {
    int total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.date.year == date.year &&
          transaction.date.month == date.month &&
          transaction.type == type) {
        total += transaction.amount;
      }
    }
    return total;
  }
}
