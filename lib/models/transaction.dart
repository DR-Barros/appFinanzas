/*
* Model class for Transaction
*/
class Transaction {
  final String id;
  final String title;
  final int amount;
  final DateTime date;
  final int toAccountID;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.toAccountID,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      toAccountID: json['toAccountID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'toAccountID': toAccountID,
    };
  }
}