import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/planning.dart';
import 'package:app_finanzas/views/widgets/date_input_field.dart';
import 'package:flutter/material.dart';

void showAddTransactionModal(BuildContext context,
    List<Account> accounts, DateTime date, VoidCallback callback) {
  AppController appController = AppController();
  final _dateController = TextEditingController();
  String title = '';
  int amount = 0;
  Account? toAccount;
  Account? fromAccount;
  String type = '';
  // agregamos una cuenta "pago" con id -1 para que el usuario pueda seleccionar que no se va a transferir a ninguna cuenta

  List<Account> toAccounts = List.from(accounts);
  toAccounts.add(Account(id: -1, name: 'Pago', balance: 0));
  List<PlanningItem> typeTransaction = appController.getPlanningsByMouth(date);
  typeTransaction.add(PlanningItem(id: -1, name: "transferencia entre cuentas", type: "transferencia", value: 0));
  typeTransaction.add(PlanningItem(id: -2, name: "Ahorro", type: "Ahorro", value: 0));

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar transacción'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Concepto'),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = int.parse(value);
                  },
                ),
                DateInputField(controller: _dateController),
                DropdownButtonFormField(
                    items: typeTransaction
                        .map((transaction) => DropdownMenuItem(
                              value: transaction.name,
                              child: Text(transaction.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      type = value as String;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Tipo de transacción')),
                DropdownButtonFormField(
                  items: accounts
                      .map((account) => DropdownMenuItem(
                            value: account,
                            child: Text(account.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    fromAccount = value;
                  },
                  decoration: const InputDecoration(labelText: 'Cuenta origen'),
                  validator: (value) => value == toAccount
                      ? 'La cuenta origen no puede ser la misma que la cuenta destino'
                      : null,
                ),
                DropdownButtonFormField(
                  items: toAccounts
                      .map((account) => DropdownMenuItem(
                            value: account,
                            child: Text(account.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    toAccount = value;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Cuenta destino'),
                  validator: (value) => value == fromAccount
                      ? 'La cuenta destino no puede ser la misma que la cuenta origen'
                      : null,
                ),
                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () {
                  if (title.isEmpty || amount == 0) {
                    return;
                  } else if (fromAccount == null) {
                    return;
                  } else if (toAccount == null) {
                    return;
                  } else if (type == '') {
                    return;
                  }
                  appController.addTransaction(
                      title,
                      amount,
                      DateTime.parse(_dateController.text),
                      fromAccount,
                      toAccount,
                      type);
                  callback();
                  Navigator.of(context).pop();
                },
                child: const Text('Agregar')),
          ],
        );
      });
}
