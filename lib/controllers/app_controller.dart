import 'dart:convert';
import 'package:app_finanzas/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController {
  User? user;

  // Singleton instance of AppController.
  static final AppController _instance = AppController._internal();

  // Private constructor to prevent instantiation.
  AppController._internal() {
    getUser();
  }

  // Factory constructor to return the singleton instance.
  factory AppController() {
    return _instance;
  }

  // Method to get the user from local storage.
  Future<void> getUser() async {
    final data = await SharedPreferences.getInstance();
    final userJson = data.getString('user');
    if (userJson != null) {
      try {
        final jsonData = json.decode(userJson) as Map<String, dynamic>;
        user = User.fromJson(jsonData);
      } catch (e) {
        user = User(
          id: '0',
          name: 'invitado',
          email: 'invitado@example.com',
        );
      }
    }
  }

  // Method to save the user to local storage.
  Future<void> saveUser() async {
    final data = await SharedPreferences.getInstance();
    final userJson = json.encode(user!.toJson());
    await data.setString('user', userJson);
  }

  // Method to add a income to the user
  void addIncome(String name, int amount, DateTime date, int accountId) {
    user!.addIncome(name, amount, date, accountId);
    saveUser();
  }
}
