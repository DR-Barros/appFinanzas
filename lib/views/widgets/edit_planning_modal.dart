import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/planning.dart';
import 'package:flutter/material.dart';
void showEditPlanningModal(BuildContext context, DateTime currentDate, List<PlanningItem> plannings, int id, Function callback) {
  AppController appController = AppController();
  final PlanningItem planning = appController.getPlanningsByMouth(currentDate).firstWhere((element) => element.id == id);
  String name = planning.name;
  String type = planning.type;
  int percentage = type == 'percentage' ? planning.value : 0;
  int amount = type == 'fixed' ? planning.value : 0;

  showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: const Text('Editar item de planificación'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Item de planificación'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: name),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Monto a planificar'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = int.tryParse(value) ?? amount;
                },
                controller: TextEditingController(text: amount.toString()),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Porcentaje a planificar'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  percentage = int.tryParse(value) ?? percentage;
                },
                controller: TextEditingController(text: percentage.toString()),
              ),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    value: 'fixed',
                    child: const Text('Valor fijo'),
                  ),
                  DropdownMenuItem(
                    value: 'percentage',
                    child: const Text('Porcentaje'),
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
            child: const Text('Cancelar')
          ),
          TextButton(
            onPressed: () {
              planning.update(name, type, amount, percentage);
              callback();
              Navigator.pop(context);
            }, 
            child: const Text('Guardar')
          ),
        ],
      
      );
    }
  );

}