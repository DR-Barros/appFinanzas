import 'package:app_finanzas/models/account.dart';

class SaveAccount extends Account {
  SaveAccount({
    required id,
    required name,
    required balance,
  }) : super(id: id, name: name, balance: balance, type: 'savings');

  factory SaveAccount.fromJson(Map<String, dynamic> json) {
    return SaveAccount(
      id: json['id'],
      name: json['name'],
      balance: json['balance'],
    );
  }
}
