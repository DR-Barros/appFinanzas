import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/planning.dart';
import 'package:flutter/material.dart';

void showEditPlanningModal(BuildContext context, DateTime currentDate,
    List<PlanningItem> plannings, int id, Function callback) {
  AppController appController = AppController();
  final PlanningItem planning = appController
      .getPlanningsByMouth(currentDate)
      .firstWhere((element) => element.id == id);
  String name = planning.name;
  String type = planning.type;
  int amount = planning.type == 'fixed' ? planning.value : 0;
  int percentage = planning.type == 'percentage' ? planning.value : 0;
  final _amountController = TextEditingController(
      text: type == 'fixed' ? planning.value.toString() : '');
  final _percentageController = TextEditingController(
      text: type == 'percentage' ? planning.value.toString() : '');

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar item de planificación'),
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
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  controller: _amountController,
                  decoration:
                      const InputDecoration(labelText: 'Monto a planificar'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = int.tryParse(value) ?? 0;
                  },
                  
                ),
                TextField(
                  controller: _percentageController,
                  decoration: const InputDecoration(
                      labelText: 'Porcentaje a planificar'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    percentage = int.tryParse(value) ?? 0;
                  },
                  
                ),
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
                    type = value.toString();
                  },
                  value: type,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () {
                  appController.updatePlanningItem(currentDate,
                      id, name, type, percentage, amount);
                  callback();
                  Navigator.pop(context);
                },
                child: const Text('Guardar')),
          ],
        );
      });
}
