import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/planning.dart';
import 'package:app_finanzas/views/widgets/date_input_field.dart';
import 'package:flutter/material.dart';

void showAddTransactionModal(BuildContext context, List<Account> accounts,
    DateTime date, VoidCallback callback) {
  AppController appController = AppController();
  final _dateController = TextEditingController();
  String title = '';
  int amount = 0;
  Account? toAccount;
  Account? fromAccount;
  String type = '';
  int installment = 0; // numero de cuotas
  //List<PlanningItem> typeTransaction = appController.getPlanningsByMouth(date);
  // quiero que typeTransaction sea una copia de la lista de plannings, pero que no se modifique la lista original

  List<PlanningItem> typeTransaction =
      List.from(appController.getPlanningsByMouth(date));
  typeTransaction.add(PlanningItem(
      id: -1,
      name: "transferencia entre cuentas",
      type: "transferencia",
      value: 0));
  typeTransaction
      .add(PlanningItem(id: -2, name: "Ahorro", type: "Ahorro", value: 0));

  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState){
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
                          setState(() {
                            type = value.toString();
                          });
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
                        setState(() {
                          fromAccount = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Cuenta origen'),
                      validator: (value) => value == toAccount
                          ? 'La cuenta origen no puede ser la misma que la cuenta destino'
                          : null,
                    ),
                    if (type == 'transferencia entre cuentas' || type == 'Ahorro')
                      DropdownButtonFormField(
                        items: accounts
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
                    if (fromAccount != null && fromAccount!.type == AccountType.credit)
                      TextField(
                        decoration: const InputDecoration(labelText: 'Número de cuotas'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          installment = int.parse(value);
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
                    child: const Text('Cancelar')),
                ElevatedButton(
                    onPressed: () {
                      if (title.isEmpty || amount == 0) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'El concepto y el monto no pueden estar vacíos'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Aceptar')),
                              ],
                            );
                          },
                        );
                        return;
                      } else if (fromAccount == null) {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Seleccione una cuenta origen'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        });
                        return;
                      } else if (type != 'transferencia entre cuentas' &&
                          type != 'Ahorro') {
                          debugPrint('corrigiendo error de tipo: $type');
                          toAccount = Account(id: -1, name: 'Pago');
                      } else if (toAccount == null) {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Seleccione una cuenta destino'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        });
                        return;
                      } else if (type == '') {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Seleccione un tipo de transacción'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        });
                        return;
                      } else if (_dateController.text.isEmpty) {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Seleccione una fecha'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        });
                        return;
                      }
                      debugPrint('Adding transaction from: ${fromAccount!.id} to: ${toAccount!.id}');
                      if (installment > 0){
                        for (int i = 0; i < installment; i++){
                          DateTime date = DateTime.parse(_dateController.text);
                          date = date.add(Duration(days: 30 * i));
                          appController.addTransaction(
                            '$title cuota ${i + 1}/$installment',
                            (amount/installment).round(),
                            date,
                            fromAccount,
                            toAccount,
                            type);
                        }
                      }  else {
                        appController.addTransaction(
                            title,
                            amount,
                            DateTime.parse(_dateController.text),
                            fromAccount,
                            toAccount,
                            type);
                      }
                      callback();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Agregar')),
              ],
            );
        });
      }
      
      );
}
