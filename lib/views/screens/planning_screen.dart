import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:flutter/material.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  AppController appController = AppController();

  @override
  Widget build(BuildContext context) {
    String userName = appController.getUserName();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificación de gastos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenido $userName'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
