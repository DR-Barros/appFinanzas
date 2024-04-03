import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/views/widgets/date_input_field.dart';
import 'package:flutter/material.dart';

void showAddIncomeModal(BuildContext context,
    List<Account> accounts, VoidCallback callback) {
  AppController appController = AppController();
  final _dateController = TextEditingController();
  String title = '';
  int amount = 0;
  Account? toAccount;

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar ingreso'),
          content: Column(
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
                          value: account,
                          child: Text(account.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  toAccount = value as Account;
                },
                decoration: const InputDecoration(labelText: 'Cuenta'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () {
                  appController.addIncome(title, amount,
                      DateTime.parse(_dateController.text), toAccount!);
                  callback();
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar')),
          ],
        );
      });
}
