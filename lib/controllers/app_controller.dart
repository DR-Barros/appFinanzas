import 'dart:convert';
import 'package:app_finanzas/models/user.dart';
import 'package:app_finanzas/models/transaction.dart';
import 'package:app_finanzas/models/save_account.dart';
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
    print("User JSON: $userJson");
    if (userJson != null) {
      try {
        final jsonData = json.decode(userJson) as Map<String, dynamic>;
        user = User.fromJson(jsonData);
        print('User loaded: ${user!.name}');
      } catch (e) {
        print('Error loading user: $e');
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

  int getBalance() {
    return user!.accounts.fold(
      0,
      (previousValue, element) => previousValue + element.balance,
    );
  }

  String getBalanceString() {
    String str = getBalance().toString();
    // add dots every 3 digits
    for (int i = str.length - 3; i > 0; i -= 3) {
      str = str.substring(0, i) + '.' + str.substring(i);
    }
    return str;
  }

  // Method to add a income to the user
  void addIncome(String name, int amount, DateTime date, int accountId) {
    user!.addIncome(name, amount, date, accountId);
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
}
