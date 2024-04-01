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
      expect(account.type, 'current');
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
          type: "savings");

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.balance, 100);
      expect(account.transactions, [transaction1, transaction2]);
      expect(account.type, 'savings');
    });

    // Test para verificar la creación de una instancia de Account a partir de un mapa JSON.
    test('Account is created from JSON (empty transactions, no type)', () {
      final accountJson = {
        'id': 1,
        'name': 'John Doe',
        'balance': 100,
        'transactions': [],
        'type': 'current',
      };
      final account = Account.fromJson(accountJson);

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.balance, 100);
      expect(account.transactions, isEmpty);
      expect(account.type, 'current');
    });

    test('Account is created from JSON (with transactions)', () {
      final transaction1Json = {
        'id': '1',
        'title': 'Payment',
        'amount': 50,
        'date': DateTime.now().toIso8601String(),
        'toAccountID': 2,
        'type': 'income',
      };
      final transaction2Json = {
        'id': '2',
        'title': 'Transfer',
        'amount': 25,
        'date': DateTime.now().toIso8601String(),
        'toAccountID': 2,
        'type': 'expense',
      };
      final accountJson = {
        'id': 1,
        'name': 'John Doe',
        'balance': 100,
        'transactions': [transaction1Json, transaction2Json],
        'type': 'savings',
      };
      final account = Account.fromJson(accountJson);

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.balance, 100);
      expect(account.transactions.length, 2);
      expect(account.transactions[0].id, '1');
      expect(account.transactions[1].id, '2');
      expect(account.type, 'savings');
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

    // Test para verificar el método addTransaction de la clase Account.
    test('Transaction is added to the account', () {
      final transaction = Transaction(
        id: '1',
        title: 'Payment',
        amount: 50,
        date: DateTime.now(),
        toAccountID: 2,
      );
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100,
      );

      account.addTransaction(transaction);

      expect(account.transactions, [transaction]);
      expect(account.balance, 50);
    });

    // Test para verificar el método addIncome de la clase Account.
    test('Income is added to the account', () {
      final transaction = Transaction(
        id: '1',
        title: 'Payment',
        amount: 50,
        date: DateTime.now(),
        toAccountID: 1,
        type: 'income',
      );
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100,
      );

      account.addIncome(transaction);

      expect(account.transactions, []);
      expect(account.balance, 150);
    });

    // Test para verificar el método getTransactionsByMonth de la clase Account.
    test('Transactions are filtered by month', () {
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
        date: DateTime.now().subtract(Duration(days: 60)),
        toAccountID: 2,
      );
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100,
        transactions: [transaction1, transaction2],
      );

      final transactions = account.getTransactionsByMonth(DateTime.now());

      expect(transactions, [transaction1]);
    });

    // Test para verificar el método getBalanceString de la clase Account.
    test('Balance is formatted as a string', () {
      final account = Account(
        id: 1,
        name: 'John Doe',
        balance: 100000,
      );

      final balanceString = account.getBalanceString();

      expect(balanceString, '100.000');
    });
  });
}
