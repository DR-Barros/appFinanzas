import 'package:app_finanzas/views/widgets/edit_planning_income_modal.dart';
import 'package:flutter/material.dart';
import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/views/widgets/add_planning_modal.dart';
import 'package:app_finanzas/views/widgets/edit_planning_modal.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  AppController appController = AppController();
  DateTime currentDate = DateTime.now();

  _nextMonth() {
    DateTime next = DateTime(currentDate.year, currentDate.month + 1);
    if (next.isAfter(DateTime.now())) {
      return;
    } else {
      setState(() {
        currentDate = DateTime(currentDate.year, currentDate.month + 1);
      });
    }
  }

  _previousMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> plannings =
        appController.showPlanningsByMouth(currentDate);
    String date = '${currentDate.month}/${currentDate.year}';
    String planningIncome =
        appController.getPlanningIncomeByMonthString(currentDate);
    bool showPlanningIncome = appController.showPlanningIncome;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Planificación de gastos'),
        ),
        body: SingleChildScrollView(
          child:  Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        _previousMonth();
                      },
                      icon: const Icon(Icons.arrow_left)),
                  Expanded(
                    child: Text(
                      'Planificación de $date',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _nextMonth();
                      },
                      icon: const Icon(Icons.arrow_right)),
                ],
              ),
              if (showPlanningIncome)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      'Ingresos planificados: $planningIncome',
                    )),
                    ElevatedButton.icon(
                      onPressed: () {
                        ShowEditPlanningIncomeModal(context, currentDate,
                            appController.getPlanningIncomeByMonth(currentDate), 
                            () {
                          setState(() {});
                        });
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    )
                  ],
                ),
              ),
              if (!showPlanningIncome)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 10,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Item'),),
                    DataColumn(label: Text('\$')),
                    DataColumn(label: Text('%')),
                    DataColumn(label: Text('Gasto')),
                    DataColumn(label: Text('Diferencia')),
                    DataColumn(label: Text('editar')),
                  ],
                  rows: plannings
                      .map((planning) => DataRow(cells: <DataCell>[
                            DataCell(Text(planning['name'])),
                            DataCell(Text(planning['realValue'].toString())),
                            DataCell(Text(planning['realPercentage'].toString())),
                            DataCell(Text(planning['expense'].toString())),
                            DataCell(Text(planning['difference'].toString())),
                            if (planning['id'] >= 0)
                            DataCell(IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showEditPlanningModal(context, currentDate,
                                    appController.getPlanningsByMouth(currentDate), planning['id'],
                                    () {
                                  setState(() {});
                                });
                              },
                            ))  
                            else
                            const DataCell(Text(''))
                          ]))
                      .toList(),
                ),
              ),
              if (showPlanningIncome)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 10,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Item'),
                    ),
                    DataColumn(
                      label: Text('P. \$'),
                    ),
                    DataColumn(
                      label: Text('P. %'),
                    ),
                    DataColumn(label: Text('\$')),
                    DataColumn(label: Text('%')),
                    DataColumn(label: Text('Gasto')),
                    DataColumn(label: Text('Diferencia')),
                  ],
                  rows: plannings
                      .map((planning) => DataRow(cells: <DataCell>[
                            DataCell(Text(planning['name'])),
                            DataCell(Text(planning['planningValue'].toString())),
                            DataCell(
                                Text(planning['planningPercentage'].toString())),
                            DataCell(Text(planning['realValue'].toString())),
                            DataCell(Text(planning['realPercentage'].toString())),
                            DataCell(Text(planning['expense'].toString())),
                            DataCell(Text(planning['difference'].toString())),
                          ]))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            showAddPlanningModal(context, currentDate,
                appController.getPlanningIncomeByMonth(currentDate), () {
              setState(() {});
            })
          },
          child: const Icon(Icons.add),
        ));
  }
}
