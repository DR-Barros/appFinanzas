import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/views/widgets/add_account_modal.dart';
import 'package:app_finanzas/models/save_account.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key});

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  AppController appController = AppController();

  @override
  Widget build(BuildContext context) {
    String dinero = appController.getBalanceString();
    List<SaveAccount> cuentas = appController.getSaveAccounts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
      ),
      body: Column(
        children: <Widget>[
          Text('Tienes \$ $dinero en tus cuentas'),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const Text('Cuentas de ahorro'),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cuentas.length,
                  itemBuilder: (context, index) {
                    final cuenta = cuentas[index];
                    return ListTile(
                      title: Text(cuenta.name),
                      subtitle: Text(cuenta.balance.toString()),
                    );
                  },
                ),
              ],
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddAccountModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
