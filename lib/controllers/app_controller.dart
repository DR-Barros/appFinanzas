import 'dart:async';
import 'dart:convert';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/planning.dart';
import 'package:app_finanzas/models/user.dart';
import 'package:app_finanzas/models/transaction.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController {
  User? user;
  bool showPlanningIncome = false;

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
    await getData();
  }

  /// Method to get the controller data from local storage.
  Future<void> getData() async {
    final data = await SharedPreferences.getInstance();
    final showPlaningState = data.getBool('showPlanningIncome');
    if (showPlaningState != null) {
      showPlanningIncome = showPlaningState;
    } else {
      showPlanningIncome = false;
    }
    getUser();
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

  /// Method to save the user to local storage.
  Future<void> saveUser() async {
    final data = await SharedPreferences.getInstance();
    final userJson = json.encode(user!.toJson());
    await data.setString('user', userJson);
    await data.setBool('showPlanningIncome', showPlanningIncome);
  }

  // Method to reset the user to the default user.
  Future<void> resetUser() async {
    final data = await SharedPreferences.getInstance();
    await data.remove('user');
    user = User(
      id: '0',
      name: 'invitado',
      email: '',
      password: "",
      accounts: [],
      transactions: [],
    );
    saveUser();
  }

  /// Method to get the user name.
  String getUserName() {
    return user?.name ?? 'No user';
  }

  /// Method to get the balance of the user.
  int getBalance() {
    return user!.getBalance();
  }

  /// Method to get the balance of the save accounts of the user.
  int getSaveBalance() {
    return user!.getSaveBalance();
  }

  // Method to add a income to the user
  void addIncome(String name, int amount, DateTime date, Account? toAccount) {
    if (user == null || toAccount == null) {
      Logger().d('User is null or account ID is -1');
      return;
    }
    user!.addIncome(name, amount, date, toAccount);
    saveUser();
  }

  // Method to add a transaction to the user
  void addTransaction(String title, int amount, DateTime date,
      Account? fromAccount, Account? toAccount, String type) {
    if (user == null ||
        fromAccount?.id == -1 ||
        toAccount == null ||
        fromAccount == null) {
      Logger().d('User is null, account ID is -1 or toAccount is null');
      return;
    }
    user!.addTransaction(title, amount, date, fromAccount, toAccount, type);
    saveUser();
  }

  // Method to add an account to the user
  void addAccount(String name, int balance, String type) {
    user!.addAccount(name, balance, type);
    saveUser();
  }

  /// Method to edit a planning income
  void editPlanningIncome(DateTime date, int amount) {
    user!.editPlanningIncome(date, amount);
    saveUser();
  }

  void addPlanningItem(
      String name, int amount, String type, int percentage, DateTime date) {
    user!.addPlanningItem(name, amount, type, percentage, date);
    saveUser();
  }

  // Method to list the incomes of the user
  List<Transaction> getIncomes() {
    if (user != null) {
      return user!.transactions
          .where((transaction) => transaction.type == 'income')
          .toList();
    }
    return [];
  }

  // Method to list the incomes of the user by month
  List<Transaction> getIncomesByMouth(DateTime date) {
    if (user != null) {
      return user!.transactions
          .where((transaction) =>
              transaction.date != null &&
              transaction.date!.year == date.year &&
              transaction.date!.month == date.month &&
              transaction.type == 'income')
          .toList();
    } else {
      return [];
    }
  }

  // Method to list the accounts of the user, returns a list with
  // the name of the account and the id of the account.
  List<Account> getAccounts() {
    if (user != null) {
      return user!.accounts;
    } else {
      return [];
    }
  }

  /// Method to get the currents accounts of the user
  List<Account> getCurrentAccounts() {
    if (user != null) {
      return user!.accounts
          .where((account) => account.type == AccountType.current)
          .map((account) => account)
          .toList();
    } else {
      return [];
    }
  }

  /// Method to get the CreditAccounts of the user
  List<Account> getCreditAccounts() {
    if (user != null) {
      return user!.accounts
          .where((account) => account.type == AccountType.credit)
          .map((account) => account)
          .toList();
    } else {
      return [];
    }
  }

  /// Method to get the SaveAccounts of the user
  List<Account> getSaveAccounts() {
    if (user != null) {
      return user!.accounts
          .where((account) => account.type == AccountType.savings)
          .map((account) => account)
          .toList();
    } else {
      return [];
    }
  }

  // Method to get the account by id
  Account getAccountById(int id) {
    if (user != null) {
      return user!.accounts.firstWhere((account) => account.id == id);
    } else {
      return Account(id: -1, name: 'No account', type: AccountType.nullType);
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

  List<PlanningItem> getPlanningsByMouth(DateTime date) {
    if (user != null) {
      return user!.getPlanningByMonth(date);
    } else {
      return [];
    }
  }

  List<Map<String, dynamic>> showPlanningsByMouth(DateTime date) {
    if (user != null) {
      return user!.showPlanningByMonth(date);
    } else {
      return [];
    }
  }

  String getPlanningIncomeByMonthString(DateTime date) {
    final formatter = NumberFormat('#,##0', 'es_AR');
    if (user != null) {
      return formatter.format(user!.getPlanningIncomeByMonth(date));
    } else {
      return '0';
    }
  }

  int getPlanningIncomeByMonth(DateTime date) {
    if (user != null) {
      return user!.getPlanningIncomeByMonth(date);
    } else {
      return 0;
    }
  }

  void updatePlanningItem(DateTime time, int id, String name, String type,
      int percentage, int amount) {
    user!.updatePlanningItem(time, id, name, type, percentage, amount);
    saveUser();
  }
}
