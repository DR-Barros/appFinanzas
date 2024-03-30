import 'package:flutter_test/flutter_test.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/transaction.dart';

void main() {
  group('Account Model Tests', () {
    // Test para verificar la creación directa de una instancia de Account.
    test('Account is created with expected values (without transactions)', () {
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100,
      );

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.balance, 100);
      expect(account.transactions, isEmpty);
    });

    // Test para verificar la creación de una instancia de Account con transacciones.
    test('Account is created with expected values (with transactions)', () {
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
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100,
        transactions: [transaction1, transaction2],
      );

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.balance, 100);
      expect(account.transactions, [transaction1, transaction2]);
    });

    // Test para verificar la creación de una instancia de Account a partir de un mapa JSON.
    test('Account is created from JSON (empty transactions)', () {
      final accountJson = {
        'id': 1,
        'name': 'John Doe',
        'balance': 100,
        'transactions': [],
      };
      final account = Account.fromJson(accountJson);

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.balance, 100);
      expect(account.transactions, isEmpty);
    });

    test('Account is created from JSON (with transactions)', () {
      final transaction1Json = {
        'id': '1',
        'title': 'Payment',
        'amount': 50,
        'date': DateTime.now().toIso8601String(),
        'toAccountID': 2,
      };
      final transaction2Json = {
        'id': '2',
        'title': 'Transfer',
        'amount': 25,
        'date': DateTime.now().toIso8601String(),
        'toAccountID': 2,
      };
      final accountJson = {
        'id': 1,
        'name': 'John Doe',
        'balance': 100,
        'transactions': [transaction1Json, transaction2Json],
      };
      final account = Account.fromJson(accountJson);

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.balance, 100);
      expect(account.transactions.length, 2);
      expect(account.transactions[0].id, '1');
      expect(account.transactions[1].id, '2');
    });

    // Test para verificar la serialización de una instancia de Account a JSON.
    test('Account is serialized to JSON', () {
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100,
        transactions: [],
      );
      final accountJson = account.toJson();

      expect(accountJson['id'], 1);
      expect(accountJson['name'], 'John Doe');
      expect(accountJson['balance'], 100);
    });

    test('Account is serialized to JSON (with transactions)', () {
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
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100,
        transactions: [transaction1, transaction2],
      );
      final accountJson = account.toJson();

      expect(accountJson['id'], 1);
      expect(accountJson['name'], 'John Doe');
      expect(accountJson['balance'], 100.0);
      expect(accountJson['transactions'], isA<List>());
      expect(accountJson['transactions'].length, 2);
    });
  });
}
