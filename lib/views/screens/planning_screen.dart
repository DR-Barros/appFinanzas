import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/transaction.dart';
import 'package:app_finanzas/views/widgets/add_transaction_modal.dart';
import 'package:flutter/material.dart';

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
    String userName = appController.getUserName();
    String date = '${currentDate.month}/${currentDate.year}';
    List<Transaction> transactions =
        appController.getTransactionsByMonth(currentDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificación de gastos'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Planificación de gastos de $userName',
            style: TextStyle(fontSize: 20),
          ),
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    _previousMonth();
                  },
                  icon: Icon(Icons.arrow_left)),
              Expanded(
                child: Text(
                  'Gastos de $date',
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
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction.title),
                subtitle: Text(transaction.getAmountString()),
                trailing: Text(transaction.date.toString()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionModal(context, appController.getAccounts(), () {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
