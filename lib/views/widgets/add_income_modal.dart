import 'package:flutter/material.dart';

void showAddIncomeModal(
    BuildContext context, List<Map<String, dynamic>> accounts) {
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
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Fecha'),
                keyboardType: TextInputType.datetime,
              ),
              DropdownButtonFormField(
                items: accounts
                    .map((account) => DropdownMenuItem(
                          value: account['id'],
                          child: Text(account['name']),
                        ))
                    .toList(),
                onChanged: (value) {},
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
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar')),
          ],
        );
      });
}
