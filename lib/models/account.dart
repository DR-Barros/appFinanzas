import 'package:app_finanzas/models/transaction.dart';
import 'package:intl/intl.dart';

/*
  This class is used to store the bank account information of the user.
*/
class Account {
  final int id;
  final String name;
  int balance;
  final List<Transaction> transactions = [];
  final String type;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    List<Transaction>? transactions,
    this.type = 'current',
  }) {
    if (transactions != null) {
      this.transactions.addAll(transactions);
    }
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      balance: json['balance'],
      transactions: (json['transactions'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'transactions':
          transactions.map((transaction) => transaction.toJson()).toList(),
      'type': type,
    };
  }

  // Method to add a transaction to the account, it also updates the balance of the account.
  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    balance -= transaction.amount;
  }

  // Method to add an income to the account (increase the balance of the account)
  void addIncome(Transaction transaction) {
    balance += transaction.amount;
  }

  // Method to get the transactions of the account by month
  List<Transaction> getTransactionsByMonth(DateTime date) {
    return transactions
        .where((transaction) =>
            transaction.date.year == date.year &&
            transaction.date.month == date.month)
        .toList();
  }

  String getBalanceString() {
    final formatter = NumberFormat('#,##0', 'es_AR');
    return formatter.format(balance);
  }

  int getTotalTransactionsByMonth(DateTime date) {
    int total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.date.year == date.year &&
          transaction.date.month == date.month) {
        total += transaction.amount;
      }
    }
    return total;
  }

  int getTotalTransactionsByMonthAndType(DateTime date, String type) {
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
