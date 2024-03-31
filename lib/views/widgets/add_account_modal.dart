import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:flutter/material.dart';

void showAddAccountModal(BuildContext context) {
  AppController appController = AppController();
  String name = '';
  int balance = 0;
  String type = 'Ahorro';

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar cuenta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Saldo'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  balance = int.parse(value);
                },
              ),
              DropdownButton<String>(
                value: type,
                items: <String>['Ahorro', 'Corriente']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  type = value!;
                },
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
                  appController.addAccount(name, balance, type);
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar')),
          ],
        );
      });
}
