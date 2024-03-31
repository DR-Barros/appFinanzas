import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_finanzas/views/widgets/add_income_modal.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  AppController appController = AppController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresos'),
      ),
      body: ListView.builder(
        itemCount: appController.getIncomes().length,
        itemBuilder: (context, index) {
          final income = appController.getIncomes()[index];
          return ListTile(
            title: Text(income.title),
            subtitle: Text(income.amount.toString()),
            trailing: Text(income.date.toString()),
          );
        },
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
