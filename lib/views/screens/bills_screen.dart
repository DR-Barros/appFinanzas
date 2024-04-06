import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/transaction.dart';
import 'package:app_finanzas/views/widgets/add_transaction_modal.dart';
import 'package:flutter/material.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
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

  _accountName(int id) {
    List<Account> accounts = appController.getAccounts();
    for (var account in accounts) {
      if (account.id == id) {
        return account.name;
      }
    }
    return 'Pago';
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
            style: const TextStyle(fontSize: 20),
          ),
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    _previousMonth();
                  },
                  icon: const Icon(Icons.arrow_left)),
              Expanded(
                child: Text(
                  'Gastos de $date',
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
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction.title),
                subtitle: Text(
                    '${transaction.getAmountString()} -> ${_accountName(transaction.toAccountID)}'),
                trailing: Text(
                    '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionModal(
              context, appController.getAccounts(), currentDate, () {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
