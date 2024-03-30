import 'package:app_finanzas/models/transaction.dart';

/*
  This class is used to store the bank account information of the user.
*/
class Account {
  final int id;
  final String name;
  int balance;
  final List<Transaction> transactions = [];

  Account({
    required this.id,
    required this.name,
    required this.balance,
    List<Transaction>? transactions,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'transactions':
          transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    balance -= transaction.amount;
  }

  void addIncome(Transaction transaction) {
    balance += transaction.amount;
  }
}
