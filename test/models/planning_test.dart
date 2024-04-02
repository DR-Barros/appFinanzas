import 'package:flutter_test/flutter_test.dart';
import 'package:app_finanzas/models/planning.dart';

void main() {
  group('Planning Model Tests', () {
    test('Planning is created with expected values', () {
      final planning = Planning(
        id: '1',
        planningIncome: 1000,
      );

      expect(planning.id, '1');
      expect(planning.planningIncome, 1000);
      expect(planning.planningItems.length, 1);
      expect(planning.planningItems[0].id, 0);
      expect(planning.planningItems[0].name, 'Ahorro');
      expect(planning.planningItems[0].type, 'saving');
      expect(planning.planningItems[0].value, 0);
    });

    test('Planning is created from JSON', () {
      final planningJson = {
        'id': '1',
        'planningIncome': 1000,
        'planningItems': [
          {
            'id': 0,
            'name': 'Ahorro',
            'type': 'saving',
            'value': 0,
          },
        ],
      };
      final planning = Planning.fromJson(planningJson);

      expect(planning.id, '1');
      expect(planning.planningIncome, 1000);
      expect(planning.planningItems.length, 1);
      expect(planning.planningItems[0].id, 0);
      expect(planning.planningItems[0].name, 'Ahorro');
      expect(planning.planningItems[0].type, 'saving');
      expect(planning.planningItems[0].value, 0);
    });

    test('Planning is converted to JSON', () {
      final planning = Planning(
        id: '1',
        planningIncome: 1000,
      );
      final planningJson = planning.toJson();

      expect(planningJson['id'], '1');
      expect(planningJson['planningIncome'], 1000);
      expect(planningJson['planningItems'].length, 1);
      expect(planningJson['planningItems'][0]['id'], 0);
      expect(planningJson['planningItems'][0]['name'], 'Ahorro');
      expect(planningJson['planningItems'][0]['type'], 'saving');
      expect(planningJson['planningItems'][0]['value'], 0);
    });

    test('PlanningItem is added to Planning', () {
      final planning = Planning(
        id: '1',
        planningIncome: 1000,
      );
      planning.addPlanningItem('Inversión', 'investment', 0);

      expect(planning.planningItems.length, 2);
      expect(planning.planningItems[1].id, 1);
      expect(planning.planningItems[1].name, 'Inversión');
      expect(planning.planningItems[1].type, 'investment');
      expect(planning.planningItems[1].value, 0);
    });

    test('PlanningItem is removed from Planning', () {
      final planning = Planning(
        id: '1',
        planningIncome: 1000,
      );
      planning.removePlanningItem(0);

      expect(planning.planningItems.length, 0);
    });

    test('PlanningItem value is updated', () {
      final planning = Planning(
        id: '1',
        planningIncome: 1000,
      );
      planning.updatePlanningItemValue(0, 100);

      expect(planning.planningItems[0].value, 100);
    });
  });

  group('PlanningItem Model Tests', () {
    test('PlanningItem is created with expected values', () {
      final planningItem = PlanningItem(
        id: 1,
        name: 'Ahorro',
        type: 'saving',
        value: 0,
      );

      expect(planningItem.id, 1);
      expect(planningItem.name, 'Ahorro');
      expect(planningItem.type, 'saving');
      expect(planningItem.value, 0);
    });

    test('PlanningItem is created from JSON', () {
      final planningItemJson = {
        'id': 1,
        'name': 'Ahorro',
        'type': 'saving',
        'value': 0,
      };
      final planningItem = PlanningItem.fromJson(planningItemJson);

      expect(planningItem.id, 1);
      expect(planningItem.name, 'Ahorro');
      expect(planningItem.type, 'saving');
      expect(planningItem.value, 0);
    });

    test('PlanningItem is converted to JSON', () {
      final planningItem = PlanningItem(
        id: 1,
        name: 'Ahorro',
        type: 'saving',
        value: 0,
      );
      final planningItemJson = planningItem.toJson();

      expect(planningItemJson['id'], 1);
      expect(planningItemJson['name'], 'Ahorro');
      expect(planningItemJson['type'], 'saving');
      expect(planningItemJson['value'], 0);
    });

    test('PlanningItem is updated with new values', () {
      final planningItem = PlanningItem(
        id: 1,
        name: 'Ahorro',
        type: 'saving',
        value: 0,
      );
      expect(planningItem.value, 0);
      planningItem.updateValue(100);
      expect(planningItem.value, 100);
    });
  });
}
