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
      expect(user.income, isEmpty);
    });

    // Test para verificar la creación de una instancia de User con cuentas y transacciones.
    test('User is created with expected values with accounts and transactions',
        () {
      final account1 = Account(
        id: 1,
        name: 'Checking Account',
        balance: 100,
      );
      final account2 = Account(
        id: 2,
        name: 'Savings Account',
        balance: 200,
      );
      final transaction1 = Transaction(
        id: '1',
        title: 'Payment',
        amount: 50,
        date: DateTime.now(),
        toAccountID: 2,
      );
      final transaction2 = Transaction(
        id: '2',
        title: 'Transfer',
        amount: 25,
        date: DateTime.now(),
        toAccountID: 2,
      );
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'John@mail.com',
        password: "password123",
        accounts: [account1, account2],
        income: [transaction1, transaction2],
      );

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'John@mail.com');
      expect(user.password, 'password123');
      expect(user.accounts, [account1, account2]);
      expect(user.income, [transaction1, transaction2]);
    });

    // Test para verificar la creación de una instancia de User a partir de un mapa JSON.
    test('User is created from JSON', () {
      final userJson = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'password': 'password123',
        'accounts': [],
        'income': [],
      };
      final user = User.fromJson(userJson);

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.password, 'password123');
      expect(user.accounts, isEmpty);
      expect(user.income, isEmpty);
    });

    // Test para verificar la serialización de una instancia de User a JSON.
    test('User is serialized to JSON', () {
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        accounts: [],
        income: [],
      );
      final userJson = user.toJson();

      expect(userJson['id'], '1');
      expect(userJson['name'], 'John Doe');
      expect(userJson['email'], 'john@example.com');
      expect(userJson['password'], 'password123');
      expect(userJson['accounts'], isEmpty);
      expect(userJson['income'], isEmpty);
    });
  });
}
