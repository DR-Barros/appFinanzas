import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/save_account.dart';
import 'package:app_finanzas/models/transaction.dart';

/*
* Model class for User
*/

class User {
  String? id;
  String name;
  String email;
  String? password;
  List<Account> accounts = [];
  List<Transaction> income = [];

  User(
      {this.id,
      required this.name,
      required this.email,
      this.password,
      List<Account>? accounts,
      List<Transaction>? income}) {
    if (accounts != null) {
      this.accounts.addAll(accounts);
    }
    if (income != null) {
      this.income.addAll(income);
    }
  }

  // Named constructor to create a User instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      accounts: (json['accounts'] as List).map((account) {
        Account accountTemp = Account.fromJson(account);
        if (accountTemp.type == 'savings')
          return SaveAccount.fromJson(account);
        else
          return Account.fromJson(account);
      }).toList(),
      income: (json['income'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
    );
  }

  // Method to convert a User instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'accounts': accounts.map((account) => account.toJson()).toList(),
        'income': income.map((transaction) => transaction.toJson()).toList(),
      };

  // Method to add an account to the user's list of accounts.
  void addAccount(String name, int balance, String type) {
    Account account;
    if ("Ahorro" == type) {
      account = SaveAccount(
        id: accounts.length,
        name: name,
        balance: balance,
      );
    } else {
      account = Account(
        id: accounts.length,
        name: name,
        balance: balance,
      );
    }
    accounts.add(account);
  }

  // Method to add a transaction to the user's list of income transactions.
  void addIncome(String title, int amount, DateTime date, int toAccountID) {
    final transaction = Transaction(
      id: income.length.toString(),
      title: title,
      amount: amount,
      date: date,
      toAccountID: toAccountID,
    );
    income.add(transaction);
    final account = accounts.firstWhere((account) => account.id == toAccountID);
    account.addIncome(transaction);
  }

  // Method to add a transaction to the Account with the given ID.
  void addTransaction(String title, int amount, DateTime date,
      int fromAccountID, int toAccountID) {
    final transaction = Transaction(
      id: income.length.toString(),
      title: title,
      amount: amount,
      date: date,
      toAccountID: toAccountID,
    );
    income.add(transaction);
    final account = accounts.firstWhere((account) => account.id == toAccountID);
    account.addTransaction(transaction);
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    accounts.clear();
    accounts.addAll((json['accounts'] as List)
        .map((account) => Account.fromJson(account))
        .toList());
    income.clear();
    income.addAll((json['income'] as List)
        .map((transaction) => Transaction.fromJson(transaction))
        .toList());
  }
}
