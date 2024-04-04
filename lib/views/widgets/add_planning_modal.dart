import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:flutter/material.dart';

void showAddPlanningModal(
    BuildContext context, DateTime time, int money, VoidCallback callback) {
  AppController appController = AppController();
  String name = '';
  int amount = 0;
  int percentage = 0;
  String type = 'fixed';

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar item a la planificación'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Item de planificación'),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Monto a planificar'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = int.parse(value);
                    if (money != 0) {
                      percentage = (amount * 100) ~/ money;
                    } else {
                      percentage = 0;
                    }
                  },
                ),
                TextField(
                    decoration: const InputDecoration(
                        labelText: 'Porcentaje a planificar'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      percentage = int.parse(value);
                      amount = (money * percentage) ~/ 100;
                    }),
                DropdownButtonFormField(
                  items: const [
                     DropdownMenuItem(
                      value: 'fixed',
                      child: Text('Valor fijo'),
                    ),
                    DropdownMenuItem(
                      value: 'percentage',
                      child: Text('Porcentaje'),
                    ),
                  ],
                  onChanged: (value) {
                    type = value as String;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Tipo de planificación'),
                ),
                ElevatedButton(
                  onPressed: () {
                    appController.addPlanningItem(
                        name, amount, type, percentage, time);
                    callback();
                    Navigator.pop(context);
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      });
}
