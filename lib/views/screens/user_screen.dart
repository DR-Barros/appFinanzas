import 'package:flutter/material.dart';
import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/views/widgets/edit_user_modal.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  AppController appController = AppController();

  @override
  Widget build(BuildContext context) {
    String userName = appController.getUserName();
    bool showPlanningIncome = appController.showPlanningIncome;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuario'),
      ),
      body: 

      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Bienvenido $userName',
            style: const TextStyle(fontSize: 20),
          ),
          CheckboxListTile(
            value: showPlanningIncome,
            onChanged: (value) {
              appController.showPlanningIncome = value!;
              appController.saveUser();
              setState(() {
                showPlanningIncome = value;
              });
            },
            title: const Text('Mostrar ingresos planificados'),
          ),
          ElevatedButton(
            onPressed: () {
              showEditUserModal(context, () {
                setState(() {
                  userName = appController.getUserName();
                });
              });
            },
            child: const Text('Editar usuario', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              appController.resetUser();
            },
            child: const Text('Borrar datos',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
