import 'package:app_finanzas/models/account.dart';

class SaveAccount extends Account {
  SaveAccount({
    required id,
    required name,
    required balance,
  }) : super(id: id, name: name, balance: balance);
}
