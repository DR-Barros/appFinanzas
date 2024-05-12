import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:flutter/material.dart';

void showAddPlanningModal(
    BuildContext context, DateTime time, int money, VoidCallback callback) {
  AppController appController = AppController();
  String name = '';
  int amount = 0;
  int percentage = 0;
  String type = 'none';

  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    DropdownButtonFormField(
                      value: type,
                      items: const [
                        DropdownMenuItem(
                          value: 'none',
                          child: Text('Seleccione un tipo'),
                        ),
                        DropdownMenuItem(
                          value: 'fixed',
                          child: Text('Valor fijo'),
                        ),
                        DropdownMenuItem(
                          value: 'percentage',
                          child: Text('Porcentaje'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                      decoration:
                          const InputDecoration(labelText: 'Tipo de planificación'),
                    ),
                    if (type == 'fixed')
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
                    if (type == 'percentage')
                      TextField(
                          decoration: const InputDecoration(
                              labelText: 'Porcentaje a planificar'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            percentage = int.parse(value);
                            amount = (money * percentage) ~/ 100;
                          }),
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
                ElevatedButton(
                  onPressed: () {
                        if (name.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Ingrese un nombre'),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Aceptar')),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        if (type == 'none') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Seleccione un tipo de planificación'),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Aceptar')),
                                ],
                              );
                            },
                          );
                          return;
                        } else if (type == 'fixed' && amount == 0) {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Ingrese un monto'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Aceptar')),
                              ],
                            );
                          });
                          return;
                        } else if (type == 'percentage' && percentage == 0) {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Ingrese un porcentaje'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Aceptar')),
                              ],
                            );
                          });
                          return;
                        }

                        appController.addPlanningItem(
                            name, amount, type, percentage, time);
                        callback();
                        Navigator.pop(context);
                      },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      });
}
