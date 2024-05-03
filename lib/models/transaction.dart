/// Transaction model
class Transaction {
  final int id;
  final String title;
  final int amount;
  DateTime? date;
  final int fromAccountID;
  final int toAccountID;
  String type;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.toAccountID,
    required this.fromAccountID,
    date,
    this.type = 'income',
  }) {
    if (date != null) {
      this.date = date;
    }
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      toAccountID: json['toAccountID'],
      fromAccountID: json['fromAccountID'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date?.toIso8601String(),
      'toAccountID': toAccountID,
      'fromAccountID': fromAccountID,
      'type': type,
    };
  }

  void updateType(String type) {
    this.type = type;
  }
}
