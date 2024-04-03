import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/views/widgets/date_input_field.dart';
import 'package:flutter/material.dart';

void showAddTransactionModal(BuildContext context,
    List<Map<String, dynamic>> accounts, DateTime date, VoidCallback callback) {
  AppController appController = AppController();
  final _dateController = TextEditingController();
  String title = '';
  int amount = 0;
  int toAccountID = -1;
  int fromAccountID = -1;
  String type = '';
  // agregamos una cuenta "pago" con id -1 para que el usuario pueda seleccionar que no se va a transferir a ninguna cuenta

  List<Map<String, dynamic>> toAccounts = List.from(accounts);
  toAccounts.add({'id': -1, 'name': 'Pago'});
  List<Map<String, dynamic>> typeTransaction =
      appController.getPlanningsByMouth(date);

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
                  items: accounts
                      .map((account) => DropdownMenuItem(
                            value: account['id'],
                            child: Text(account['name']),
                          ))
                      .toList(),
                  onChanged: (value) {
                    fromAccountID = value as int;
                  },
                  decoration: const InputDecoration(labelText: 'Cuenta origen'),
                  validator: (value) => value == fromAccountID
                      ? 'La cuenta origen no puede ser la misma que la cuenta destino'
                      : null,
                ),
                DropdownButtonFormField(
                  items: toAccounts
                      .map((account) => DropdownMenuItem(
                            value: account['id'],
                            child: Text(account['name']),
                          ))
                      .toList(),
                  onChanged: (value) {
                    toAccountID = value as int;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Cuenta destino'),
                  validator: (value) => value == fromAccountID
                      ? 'La cuenta destino no puede ser la misma que la cuenta origen'
                      : null,
                ),
                DropdownButtonFormField(
                    items: typeTransaction
                        .map((transaction) => DropdownMenuItem(
                              value: transaction['name'],
                              child: Text(transaction['name']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      type = value as String;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Tipo de transacción')),
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
                  } else if (fromAccountID == -1) {
                    return;
                  } else if (toAccountID == -1) {
                    print("toAccountID: $toAccountID");
                  } else if (type == '') {
                    return;
                  }
                  appController.addTransaction(
                      title,
                      amount,
                      DateTime.parse(_dateController.text),
                      fromAccountID,
                      toAccountID,
                      type);
                  callback();
                  Navigator.of(context).pop();
                },
                child: const Text('Agregar')),
          ],
        );
      });
}
