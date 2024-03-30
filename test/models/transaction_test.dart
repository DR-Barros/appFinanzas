import 'package:flutter_test/flutter_test.dart';
import 'package:app_finanzas/models/transaction.dart';

void main() {
  group("Transaction Model Tests", () {
    test("Transaction is created with expected values", () {
      final transaction = Transaction(
        id: "1",
        title: "Payment",
        amount: 50,
        date: DateTime.now(),
        toAccountID: 2,
      );

      expect(transaction.id, "1");
      expect(transaction.title, "Payment");
      expect(transaction.amount, 50);
      expect(transaction.date, isA<DateTime>());
      expect(transaction.toAccountID, 2);
    });

    test("Transaction is created from JSON", () {
      final transactionJson = {
        'id': '1',
        'title': 'Payment',
        'amount': 50,
        'date': DateTime.now().toIso8601String(),
        'toAccountID': 2,
      };
      final transaction = Transaction.fromJson(transactionJson);

      expect(transaction.id, '1');
      expect(transaction.title, 'Payment');
      expect(transaction.amount, 50);
      expect(transaction.date, isA<DateTime>());
      expect(transaction.toAccountID, 2);
    });

    test("Transaction is serialized to JSON", () {
      final transaction = Transaction(
        id: '1',
        title: 'Payment',
        amount: 50,
        date: DateTime.now(),
        toAccountID: 2,
      );
      final transactionJson = transaction.toJson();

      expect(transactionJson['id'], '1');
      expect(transactionJson['title'], 'Payment');
      expect(transactionJson['amount'], 50);
      expect(transactionJson['date'], isA<String>());
      expect(transactionJson['toAccountID'], 2);
    });
  });
}
