import 'package:flutter_test/flutter_test.dart';
import 'package:app_finanzas/controllers/app_controller.dart';

void main() {
  group('App Controller Tests', () {
    // Test to verify the creation of a singleton instance of AppController.
    test('AppController is a singleton', () {
      final controller1 = AppController();
      final controller2 = AppController();

      expect(controller1, controller2);
    });

    // Test to verify the initialization of the controller.
    test('AppController is initialized with user', () async {
      final controller = AppController();
      await controller.init();

      expect(controller.user, isNotNull);
    });

    // Test to verify the saving and loading of the user.
    test('User is saved and loaded', () async {
      final controller = AppController();
      await controller.init();

      final user = controller.user;
      controller.user = null;
      await controller.getUser();

      expect(controller.user, user);
    });

    // Test to verify the user name.
    test('User name is returned', () async {
      final controller1 = AppController();
      await controller1.init();

      expect(controller1.getUserName(), 'invitado');
    });
  });
}
