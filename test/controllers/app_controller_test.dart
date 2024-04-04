import 'package:app_finanzas/models/account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_finanzas/models/user.dart';

void main() {
  group('App Controller Tests', () {
    // Test to verify the creation of a singleton instance of AppController.
    test('AppController is a singleton', () {
      final controller1 = AppController();
      final controller2 = AppController();

      expect(controller1, controller2);
    });

    // Test to verify the initialization of the controller.
    test('AppController is initialized with user', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      expect(controller.user, isNotNull);
      expect(controller.user!.id, '1');
      expect(controller.user!.name, 'John Doe');
      expect(controller.user!.email, '');
      expect(controller.user!.password, '');
      expect(controller.user!.accounts, isEmpty);
      expect(controller.user!.income, isEmpty);
      expect(controller.user!.plannings, isEmpty);
    });

    // Test saveUser method.
    test('AppController saves user to local storage', () async {
      SharedPreferences.setMockInitialValues({});
      final controller = AppController();
      controller.user = controller.user = User(
        id: '1',
        name: 'John Doe',
        email: '',
      );
      await controller.saveUser();

      final data = await SharedPreferences.getInstance();
      final userJson = data.getString('user');
      expect(userJson, isNotNull);
      expect(userJson, isNotEmpty);
    });

    // Test resetUser method.
    test('AppController resets user to default user', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      await controller.resetUser();

      expect(controller.user, isNotNull);
      expect(controller.user!.id, '0');
      expect(controller.user!.name, 'invitado');
      expect(controller.user!.email, '');
      expect(controller.user!.password, '');
      expect(controller.user!.accounts, isEmpty);
      expect(controller.user!.income, isEmpty);
      expect(controller.user!.plannings.length, 1);
    });

    // Test getUserName method.
    test('AppController returns user name', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      final userName = controller.getUserName();
      expect(userName, 'John Doe');
    });

    // Test getBalance method.
    test('AppController returns user balance', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      int balance = controller.getBalance();
      expect(balance, 0);

      controller.user!.addAccount('Savings Account', 200, 'Ahorro');

      balance = controller.getBalance();
      expect(balance, 200);
    });

    // Test getSaveBalance method.
    test('AppController returns user save balance', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      int balance = controller.getSaveBalance();
      expect(balance, 0);

      controller.user!.addAccount('Savings Account', 200, 'Ahorro');
      controller.user!.addAccount('Checking Account', 100, 'Corriente');

      balance = controller.getSaveBalance();
      expect(balance, 200);
    });

    // Test getBalanceString method.
    test('AppController returns user balance string', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      String balance = controller.getBalanceString();
      expect(balance, '0');

      controller.user!.addAccount('Savings Account', 20000, 'Ahorros');

      balance = controller.getBalanceString();
      expect(balance, '20.000');
    });

    // Test getSaveBalanceString method.
    test('AppController returns user save balance string', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      String balance = controller.getSaveBalanceString();
      expect(balance, '0');

      controller.user!.addAccount('Savings Account', 20000, 'Ahorro');
      controller.user!.addAccount('Checking Account', 10000, 'Corriente');

      balance = controller.getSaveBalanceString();
      expect(balance, '20.000');
      expect(controller.getBalanceString(), '30.000');
    });

    // Test addIncome method.
    test('AppController adds income to user', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      controller.user!.addAccount('Savings Account', 20000, 'Ahorros');
      controller.addIncome(
          'Salary', 10000, DateTime.now(), controller.user!.accounts[0]);

      expect(controller.user!.income.length, 1);
      expect(controller.user!.income[0].title, 'Salary');
      expect(controller.user!.income[0].amount, 10000);
      expect(controller.user!.income[0].date, isNotNull);
      expect(controller.user!.income[0].toAccountID, 0);
      expect(controller.user!.accounts[0].balance, 30000);
      expect(controller.getBalance(), 30000);
    });

    // Test addIncome method without account.
    test('AppController does not add income with invalid account ID', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      controller.addIncome('Salary', 10000, DateTime.now(), null);

      expect(controller.user!.income.length, 0);
      expect(controller.user!.accounts, isEmpty);
      expect(controller.getBalance(), 0);
    });

    // Test addTransaction method.
    test('AppController adds transaction to user', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      controller.user!.addAccount('Savings Account', 20000, 'Ahorros');
      Account account = controller.user!.accounts[0];
      controller.user!.addAccount('Checking Account', 10000, 'Corriente');
      Account account2 = controller.user!.accounts[1];
      controller.addTransaction(
          'Transfer', 5000, DateTime.now(), account, account2, "savings");

      expect(controller.user!.accounts[0].balance, 15000);
      expect(controller.user!.accounts[1].balance, 15000);
      expect(controller.getBalance(), 30000);
    });

    // Test addTransaction method with invalid account ID.
    test('AppController does not add transaction with invalid account ID',
        () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();

      controller.addTransaction(
          'Transfer', 5000, DateTime.now(), null, null, "savings");

      expect(controller.user!.accounts, isEmpty);
      expect(controller.getBalance(), 0);
    });

    // Test addTransaction method with -1 account ID.
    test('AppController does not add transaction to -1 account ID', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorros');
      controller.addTransaction(
          'Transfer',
          5000,
          DateTime.now(),
          controller.user!.accounts[0],
          Account(id: -1, name: 'Invalid Account', balance: 0, type: 'savings'),
          "savings");

      expect(controller.user!.accounts[0].balance, 15000);
      expect(controller.getBalance(), 15000);
    });

    // Test addAccount method.
    test('AppController adds account to user', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorros');

      expect(controller.user!.accounts.length, 1);
      expect(controller.user!.accounts[0].name, 'Savings Account');
      expect(controller.user!.accounts[0].balance, 20000);
      expect(controller.getBalance(), 20000);
    });

    // Test getIncomes method.
    test('AppController returns user incomes', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorros');
      controller.addIncome(
          'Salary', 10000, DateTime.now(), controller.user!.accounts[0]);

      final incomes = controller.getIncomes();
      expect(incomes.length, 1);
      expect(incomes[0].title, 'Salary');
      expect(incomes[0].amount, 10000);
      expect(incomes[0].date, isNotNull);
      expect(incomes[0].toAccountID, 0);
    });

    // Test getIncomesByMouth method.
    test('AppController returns user incomes by month', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorros');
      controller.addIncome(
          'Salary', 10000, DateTime.now(), controller.user!.accounts[0]);
      controller.addIncome(
          'Bonus',
          5000,
          DateTime.now().subtract(const Duration(days: 60)),
          controller.user!.accounts[0]);

      final incomes = controller.getIncomesByMouth(DateTime.now());
      expect(incomes.length, 1);
      expect(incomes[0].title, 'Salary');
      expect(incomes[0].amount, 10000);
      expect(incomes[0].date, isNotNull);
      expect(incomes[0].toAccountID, 0);
    });

    // Test getAccounts method.
    test('AppController returns user accounts', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorros');

      final accounts = controller.getAccounts();
      expect(accounts.length, 1);
      expect(accounts[0].name, 'Savings Account');
      expect(accounts[0].id, 0);
    });

    // Test getCurrentAccounts method.
    test('AppController returns user current accounts', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorro');
      controller.addAccount('Checking Account', 10000, 'Corriente');

      final accounts = controller.getCurrentAccounts();
      expect(accounts.length, 1);
      expect(accounts[0].name, 'Checking Account');
      expect(accounts[0].balance, 10000);
    });

    // Test getSaveAccounts method.
    test('AppController returns user save accounts', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorro');
      controller.addAccount('Checking Account', 10000, 'Corriente');

      final accounts = controller.getSaveAccounts();
      expect(accounts.length, 1);
      expect(accounts[0].name, 'Savings Account');
      expect(accounts[0].balance, 20000);
    });

    // Test getTransactionsByMonth method.
    test('AppController returns user transactions by month', () async {
      SharedPreferences.setMockInitialValues({
        'user':
            '{"id":"1","name":"John Doe","email":"", "password":"", "accounts":[], "income":[], "plannings":[]}'
      });
      final controller = AppController();
      await controller.init();
      controller.addAccount('Savings Account', 20000, 'Ahorro');
      controller.addAccount('Checking Account', 10000, 'Corriente');
      controller.addTransaction(
          'Transfer',
          5000,
          DateTime.now(),
          controller.user!.accounts[0],
          controller.user!.accounts[1],
          "savings");
      controller.addTransaction(
          'Transfer',
          1000,
          DateTime.now().subtract(Duration(days: 60)),
          controller.user!.accounts[0],
          controller.user!.accounts[1],
          "savings");

      final transactions = controller.getTransactionsByMonth(DateTime.now());

      expect(transactions.length, 1);
      expect(transactions[0].title, 'Transfer');
      expect(transactions[0].amount, 5000);
      expect(transactions[0].date, isNotNull);
    });
  });
}
