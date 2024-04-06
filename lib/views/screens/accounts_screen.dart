import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/views/widgets/add_account_modal.dart';
import 'package:app_finanzas/models/account.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  AppController appController = AppController();

  @override
  Widget build(BuildContext context) {
    String dinero = appController.getBalanceString();
    String dineroAhorro = appController.getSaveBalanceString();
    List<Account> cuentas = appController.getSaveAccounts();
    List<Account> accounts = appController.getCurrentAccounts();
    List<Account> credit = appController.getCreditAccounts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              'Tienes \$ $dinero en tus cuentas',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Cuentas de ahorro',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Tienes \$ $dineroAhorro en tus cuentas de ahorro',
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: cuentas.length,
                    itemBuilder: (context, index) {
                      final cuenta = cuentas[index];
                      return ListTile(
                        title: Text(cuenta.name),
                        subtitle: Text(cuenta.getBalanceString()),
                      );
                    },
                  ),
                ],
              ),
            )),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Cuentas de Crédito',
                    style: TextStyle(fontSize: 20),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: credit.length,
                    itemBuilder: (context, index) {
                      final cuenta = credit[index];
                      return ListTile(
                        title: Text(cuenta.name),
                        subtitle: Text(cuenta.balance.toString()),
                      );
                    },
                  ),
                ],
              ),
            )),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Otras Cuentas',
                    style: TextStyle(fontSize: 20),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final cuenta = accounts[index];
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddAccountModal(context, () {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
