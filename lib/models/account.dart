import 'package:app_finanzas/models/transaction.dart';

enum AccountType { current, savings, credit, nullType }

/*
  This class is used to store the bank account information of the user.
*/
class Account {
  final int id;
  final String name;
  final AccountType type;

  Account({
    required this.id,
    required this.name,
    this.type = AccountType.current,
  }) {
    assert(id >= -1, 'Account ID must be greater than or equal to 0');
    assert(name.isNotEmpty, 'Account name must not be empty');
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      type: AccountType.values.firstWhere((e)=> e.name == json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
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
      if (transaction.date != null &&
          transaction.date!.year == date.year &&
          transaction.date!.month == date.month) {
        total += transaction.amount;
      }
    }
    return total;
  }

  int getTotalTransactionsByMonthAndType(
      DateTime date, String type, List<Transaction> transactions) {
    int total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.date != null &&
          transaction.date!.year == date.year &&
          transaction.date!.month == date.month &&
          transaction.type == type) {
        total += transaction.amount;
      }
    }
    return total;
  }
}
