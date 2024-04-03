import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:flutter/material.dart';

void ShowEditPlanningIncomeModal(
    BuildContext context, DateTime time, int money, VoidCallback callback) {
  AppController appController = AppController();
  final TextEditingController _controller =
      TextEditingController(text: money.toString());
  int amount = money;

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar ingreso planificado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Monto a planificar'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = int.parse(value);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                appController.editPlanningIncome(time, amount);
                callback();
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      });
}
