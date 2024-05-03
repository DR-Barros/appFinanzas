import 'package:flutter_test/flutter_test.dart';
import 'package:app_finanzas/models/user.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/transaction.dart';

void main() {
  group('User Model Tests', () {
    // Test para verificar la creación directa de una instancia de User.
    test(
        'User is created with expected values without account and transactions',
        () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
      );

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.password, 'password123');
      expect(user.accounts, isEmpty);
      expect(user.transactions, isEmpty);
    });

    // Test para verificar la creación de una instancia de User con cuentas y transacciones.
    test('User is created with expected values with accounts and transactions',
        () {
      final account1 = Account(
        id: 1,
        name: 'Checking Account',
      );
      final account2 = Account(
        id: 2,
        name: 'Savings Account',
      );
      final transaction1 = Transaction(
        id: 1,
        title: 'Payment',
        amount: 50,
        date: DateTime.now(),
        toAccountID: 2,
        fromAccountID: -1,
      );
      final transaction2 = Transaction(
        id: 2,
        title: 'Transfer',
        amount: 20,
        date: DateTime.now(),
        toAccountID: 1,
        fromAccountID: 2,
      );
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'John@mail.com',
        password: "password123",
        accounts: [account1, account2],
        transactions: [transaction1, transaction2],
      );

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'John@mail.com');
      expect(user.password, 'password123');
      expect(user.accounts, [account1, account2]);
      expect(user.transactions, [transaction1, transaction2]);
    });

    // Test para verificar la creación de una instancia de User a partir de un mapa JSON.
    test('User is created from JSON', () {
      final userJson = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'password': 'password123',
        'accounts': [],
        'transactions': [],
        'plannings': [],
      };
      final user = User.fromJson(userJson);

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.password, 'password123');
      expect(user.accounts, isEmpty);
      expect(user.transactions, isEmpty);
      expect(user.plannings, isEmpty);
    });

    // Test para verificar la serialización de una instancia de User a JSON.
    test('User is serialized to JSON', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        accounts: [],
        transactions: [],
        plannings: [],
      );
      final userJson = user.toJson();

      expect(userJson['id'], '1');
      expect(userJson['name'], 'John Doe');
      expect(userJson['email'], 'john@example.com');
      expect(userJson['password'], 'password123');
      expect(userJson['accounts'], isEmpty);
      expect(userJson['transactions'], isEmpty);
      expect(userJson['plannings'], isEmpty);
    });

    // Test para verificar la adición de una cuenta a la lista de cuentas del usuario.
    test('Account is added to user accounts', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: '',
      );
      user.addAccount('Checking Account', 100, 'Corriente');

      expect(user.accounts.length, 1);
      expect(user.accounts[0].name, 'Checking Account');
      expect(user.accounts[0].getBalance(user.getTransactionsByMonth(DateTime.now())), 100);
      expect(user.accounts[0].type, 'current');
      expect(user.accounts[0].id, 0);

      user.addAccount('Savings Account', 200, 'Ahorro');

      expect(user.accounts.length, 2);
      expect(user.accounts[1].name, 'Savings Account');
      expect(user.accounts[1].getBalance(user.getTransactionsByMonth(DateTime.now())), 200);
      expect(user.accounts[1].type, 'savings');
      expect(user.accounts[1].id, 1);

      user.addAccount('Investment Account', 300, 'credit');

      expect(user.accounts.length, 3);
      expect(user.accounts[2].name, 'Investment Account');
      expect(user.accounts[2].getBalance(user.getTransactionsByMonth(DateTime.now())), 300);
      expect(user.accounts[2].type, 'credit');
      expect(user.accounts[2].id, 2);
    });

    // Test para verificar la adición de una transacción a la lista de ingresos del usuario.
    test('Transaction is added to user income', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: '',
      );
      user.addAccount('Checking Account', 100, 'Corriente');
      user.addAccount('Savings Account', 200, 'Ahorros');
      user.addIncome('Checking  income', 50, DateTime.now(), user.accounts[0]);

      expect(user.income.length, 1);
      expect(user.income[0].title, 'Checking  income');
      expect(user.income[0].amount, 50);
      expect(user.income[0].toAccountID, 0);
      expect(user.income[0].id, '0');
      expect(user.accounts[0].balance, 150);
      expect(user.accounts[1].balance, 200);

      user.addIncome('Savings income', 25, DateTime.now(), user.accounts[1]);

      expect(user.income.length, 2);
      expect(user.income[1].title, 'Savings income');
      expect(user.income[1].amount, 25);
      expect(user.income[1].toAccountID, 1);
      expect(user.income[1].id, '1');
      expect(user.accounts[0].balance, 150);
      expect(user.accounts[1].balance, 225);
    });

    // Test para verificar la adición de una transacción a una cuenta específica del usuario.
    test('Transaction is added to specific account', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: '',
      );
      user.addAccount('Checking Account', 100, 'Corriente');
      user.addAccount('Savings Account', 200, 'Ahorros');

      expect(user.accounts[0].balance, 100);
      expect(user.accounts[1].balance, 200);
      expect(user.accounts[0].transactions, isEmpty);
      expect(user.accounts[1].transactions, isEmpty);

      user.addTransaction('Payment', 50, DateTime.now(), user.accounts[0],
          Account(id: -1, name: 'Other Account', balance: 0), 'Payment');

      expect(user.accounts[0].balance, 50);
      expect(user.accounts[1].balance, 200);
      expect(user.accounts[0].transactions.length, 1);
      expect(user.accounts[1].transactions, isEmpty);

      user.addTransaction('Transfer', 25, DateTime.now(), user.accounts[0],
          user.accounts[1], 'Transfer');

      expect(user.accounts[0].balance, 25);
      expect(user.accounts[1].balance, 225);
      expect(user.accounts[0].transactions.length, 2);
      expect(user.accounts[1].transactions, isEmpty);
    });

    // Test para verificar getTransactionsByMonth en User.
    test('Get transactions by month', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: '',
      );
      user.addAccount('Checking Account', 100, 'Corriente');
      Account a1 = user.accounts[0];
      user.addAccount('Savings Account', 200, 'Ahorros');
      Account a2 = user.accounts[1];
      Account a3 = Account(id: -1, name: 'Other Account', balance: 0);
      user.addTransaction('Payment', 50, DateTime.now(), a1, a3, 'Payment');
      user.addTransaction('Transfer', 25, DateTime.now(), a1, a2, 'Transfer');
      user.addTransaction('Payment', 50, DateTime.now(), a1, a3, 'Payment');
      user.addTransaction(
          'Transfer',
          25,
          DateTime.now().subtract(const Duration(days: 60)),
          a1,
          a2,
          'Transfer');
      user.addTransaction('Payment', 50,
          DateTime.now().subtract(const Duration(days: 60)), a1, a3, 'Payment');

      expect(user.getTransactionsByMonth(DateTime.now()).length, 3);
      expect(
          user
              .getTransactionsByMonth(
                  DateTime.now().subtract(const Duration(days: 60)))
              .length,
          2);
    });
  });
}
