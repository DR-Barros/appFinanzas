import 'package:flutter_test/flutter_test.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/transaction.dart';

void main() {
  group('Account Model Tests', () {
    // Test para verificar la creación directa de una instancia de Account.
    test('Account is created with expected values (without transactions)', () {
      final account1 = Account(
        id: 1,
        name: 'John Doe',
      );
      final account2 = Account(
        id: 2,
        name: 'Jane Doe',
        type: AccountType.credit,
      );
      final account3 = Account(
        id: 3,
        name: 'John Smith',
        type: AccountType.savings,
      );
      final account4 = Account(
        id: 4,
        name: 'Jane Smith',
        type: AccountType.current,
      );

      expect(account1.id, 1);
      expect(account1.name, 'John Doe');
      expect(account1.type, AccountType.current);
      expect(account2.id, 2);
      expect(account2.name, 'Jane Doe');
      expect(account2.type, AccountType.credit);
      expect(account3.id, 3);
      expect(account3.name, 'John Smith');
      expect(account3.type, AccountType.savings);
      expect(account4.id, 4);
      expect(account4.name, 'Jane Smith');
      expect(account4.type, AccountType.current);
    });

    // Test para verificar la creación de una instancia de Account a partir de un mapa JSON.
    test('Account is created from JSON (empty transactions, no type)', () {
      final accountJson = {
        'id': 1,
        'name': 'John Doe',
        'type': 'current',
      };
      final account = Account.fromJson(accountJson);

      expect(account.id, 1);
      expect(account.name, 'John Doe');
      expect(account.type, AccountType.current);
    });

    /// Test para verificar que una instancia de Account es serialized a un mapa JSON.
    test('Account is serialized to JSON', () {
      final account = Account(
        id: 1,
        name: 'John Doe',
      );
      final accountJson = account.toJson();

      expect(accountJson['id'], 1);
      expect(accountJson['name'], 'John Doe');
      expect(accountJson['type'], 'current');
    });

    // Test para verificar que el balance de una cuenta es calculado correctamente.
    test('Account balance is calculated correctly', () {
      final account = Account(
        id: 1,
        name: 'John Doe',
      );
      final transactions = [
        Transaction(
          id: 1,
          title: "pago1",
          amount: 100,
          fromAccountID: 1,
          toAccountID: 2,
        ),
        Transaction(
          id: 2,
          title: "pago2",
          amount: 50,
          fromAccountID: 2,
          toAccountID: 1,
        ),
        Transaction(
          id: 3,
          title: "pago3",
          amount: 25,
          fromAccountID: 1,
          toAccountID: 3,
        ),
      ];

      expect(account.getBalance(transactions), -75);
      transactions.add(Transaction(
        id: 4,
        title: "pago4",
        amount: 200,
        fromAccountID: 3,
        toAccountID: 1,
      ));
      expect(account.getBalance(transactions), 125);
  });

    // Test para verificar que el total de transacciones de una cuenta en un mes es calculado correctamente.
    test('Account total transactions by month is calculated correctly', () {
      final account = Account(
        id: 1,
        name: 'John Doe',
      );
      final transactions = [
        Transaction(
          id: 1,
          title: "pago1",
          amount: 100,
          fromAccountID: 1,
          toAccountID: 2,
          date: DateTime(2021, 1, 1),
        ),
        Transaction(
          id: 2,
          title: "pago2",
          amount: 50,
          fromAccountID: 2,
          toAccountID: 1,
          date: DateTime(2021, 1, 1),
        ),
        Transaction(
          id: 3,
          title: "pago3",
          amount: 25,
          fromAccountID: 1,
          toAccountID: 3,
          date: DateTime(2021, 2, 1),
        ),
      ];

      expect(account.getTotalTransactionsByMonth(DateTime(2021, 1), transactions), 150);
      expect(account.getTotalTransactionsByMonth(DateTime(2021, 2), transactions), 25);
    });

    // Test para verificar que el total de transacciones de una cuenta en un mes y tipo es calculado correctamente.
    test('Account total transactions by month and type is calculated correctly', () {
      final account = Account(
        id: 1,
        name: 'John Doe',
      );
      final transactions = [
        Transaction(
          id: 1,
          title: "pago1",
          amount: 100,
          fromAccountID: 1,
          toAccountID: 2,
          date: DateTime(2021, 1, 1),
          type: 'income',
        ),
        Transaction(
          id: 2,
          title: "pago2",
          amount: 50,
          fromAccountID: 2,
          toAccountID: 1,
          date: DateTime(2021, 1, 1),
          type: 'expense',
        ),
        Transaction(
          id: 3,
          title: "pago3",
          amount: 25,
          fromAccountID: 1,
          toAccountID: 3,
          date: DateTime(2021, 2, 1),
          type: 'income',
        ),
      ];

      expect(account.getTotalTransactionsByMonthAndType(DateTime(2021, 1), 'income', transactions), 100);
      expect(account.getTotalTransactionsByMonthAndType(DateTime(2021, 1), 'expense', transactions), 50);
      expect(account.getTotalTransactionsByMonthAndType(DateTime(2021, 2), 'income', transactions), 25);
    });

});
}