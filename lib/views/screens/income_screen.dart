import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:app_finanzas/views/widgets/add_income_modal.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  AppController appController = AppController();
  DateTime currentDate = DateTime.now();

  // Method to change the current month to the next month.
  _nextMonth() {
    //cambia el mes si es que el siguiente mes ya paso
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
    String date = '${currentDate.month}/${currentDate.year}';
    List<Transaction> incomes = appController.getIncomesByMouth(currentDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresos'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    _previousMonth();
                  },
                  icon: Icon(Icons.arrow_left)),
              Expanded(
                child: Text(
                  'Ingresos de $date',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                  onPressed: () {
                    _nextMonth();
                  },
                  icon: Icon(Icons.arrow_right)),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: incomes.length,
            itemBuilder: (context, index) {
              final income = incomes[index];
              return ListTile(
                title: Text(income.title),
                subtitle: Text(income.amount.toString()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddIncomeModal(context, appController.getAccounts(), () {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
