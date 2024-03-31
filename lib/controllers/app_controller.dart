import 'dart:convert';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/user.dart';
import 'package:app_finanzas/models/transaction.dart';
import 'package:app_finanzas/models/save_account.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController {
  User? user;

  // Singleton instance of AppController.
  static final AppController _instance = AppController._internal();

  // Private constructor to prevent instantiation.
  AppController._internal();

  // Factory constructor to return the singleton instance.
  factory AppController() {
    return _instance;
  }

  // Method to initialize the controller.
  Future<void> init() async {
    await getUser();
  }

  // Method to get the user from local storage.
  Future<void> getUser() async {
    final data = await SharedPreferences.getInstance();
    final userJson = data.getString('user');
    if (userJson != null) {
      try {
        final jsonData = json.decode(userJson) as Map<String, dynamic>;
        user = User.fromJson(jsonData);
      } catch (e) {
        Logger().e('Error getting user from local storage: $e');
        user = User(
          id: '0',
          name: 'invitado',
          email: 'invitado@example.com',
        );
      }
    } else {
      user = User(
        id: '0',
        name: 'invitado',
        email: '',
      );
      saveUser();
    }
  }

  // Method to save the user to local storage.
  Future<void> saveUser() async {
    final data = await SharedPreferences.getInstance();
    final userJson = json.encode(user!.toJson());
    await data.setString('user', userJson);
  }

  // Method to get the user name.
  String getUserName() {
    return user?.name ?? 'No user';
  }

  // Method to get the balance of the user.
  int getBalance() {
    return user!.accounts.fold(
      0,
      (previousValue, element) => previousValue + element.balance,
    );
  }

  // Method to get the balance of the save accounts of the user.
  int getSaveBalance() {
    return user!.accounts.fold(
      0,
      (previousValue, element) {
        if (element is SaveAccount) {
          return previousValue + element.balance;
        } else {
          return previousValue;
        }
      },
    );
  }

  // Method to get the balance of the user in a string format.
  String getBalanceString() {
    final formatter = NumberFormat('#,##0', 'es_AR');
    return formatter.format(getBalance());
  }

  // Method to get the balance of the save accounts of the user in a string format.
  String getSaveBalanceString() {
    String str = getSaveBalance().toString();
    // add dots every 3 digits
    for (int i = str.length - 3; i > 0; i -= 3) {
      str = str.substring(0, i) + '.' + str.substring(i);
    }
    return str;
  }

  // Method to add a income to the user
  void addIncome(String name, int amount, DateTime date, int accountId) {
    if (user == null || accountId == -1) {
      print('User is null or account ID is -1');
      return;
    }
    user!.addIncome(name, amount, date, accountId);
    saveUser();
  }

  // Method to add a transaction to the user
  void addTransaction(String title, int amount, DateTime date,
      int fromAccountID, int toAccountID) {
    if (user == null || fromAccountID == -1) {
      //print('User is null or account ID is -1');
      return;
    }
    user!.addTransaction(title, amount, date, fromAccountID, toAccountID);
    saveUser();
  }

  // Method to add an account to the user
  void addAccount(String name, int balance, String type) {
    user!.addAccount(name, balance, type);
    saveUser();
  }

  // Method to list the incomes of the user
  List<Transaction> getIncomes() {
    if (user != null) {
      return user!.income;
    } else {
      return [];
    }
  }

  // Method to list the incomes of the user by month
  List<Transaction> getIncomesByMouth(DateTime date) {
    if (user != null) {
      return user!.income
          .where((income) =>
              income.date.year == date.year && income.date.month == date.month)
          .toList();
    } else {
      return [];
    }
  }

  // Method to list the accounts of the user, returns a list with
  // the name of the account and the id of the account.
  List<Map<String, dynamic>> getAccounts() {
    if (user != null) {
      return user!.accounts.map((account) {
        return {
          'name': account.name,
          'id': account.id,
        };
      }).toList();
    } else {
      return [];
    }
  }

  // Method to get the currents accounts of the user
  List<Account> getCurrentAccounts() {
    if (user != null) {
      return user!.accounts
          .where((account) => !(account is SaveAccount))
          .map((account) => account as Account)
          .toList();
    } else {
      return [];
    }
  }

  // Method to get the SaveAccounts of the user
  List<SaveAccount> getSaveAccounts() {
    if (user != null) {
      return user!.accounts
          .where((account) => account is SaveAccount)
          .map((account) => account as SaveAccount)
          .toList();
    } else {
      return [];
    }
  }

  // Method to get the transactions of the user by month
  List<Transaction> getTransactionsByMonth(DateTime date) {
    if (user != null) {
      return user!.getTransactionsByMonth(date);
    } else {
      return [];
    }
  }
}
