import 'package:app_finanzas/controllers/app_controller.dart';
import 'package:app_finanzas/models/user.dart';
import 'package:flutter/material.dart';
void showEditUserModal(BuildContext context, Function callback) {
  AppController appController = AppController();
  final User user = appController.user!;
  final _nameController = TextEditingController(text: user.name);
  final _emailController = TextEditingController(text: user.email);
  final _passwordController = TextEditingController(text: user.password);
  String name = user.name;
  String email = user.email;
  String password = user.password ?? '';

  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  name = value;
                },
                controller: _nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                controller: _emailController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  password = value;
                },
                controller: _passwordController,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              user.update(name, email, password);
              appController.saveUser();
              callback();
              Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    }
  );

}