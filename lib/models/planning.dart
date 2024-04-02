/**
 * Model class for Planning 
 */
class Planning {
  final String id;
  int planningIncome;
  List<PlanningItem> planningItems = [
    PlanningItem(id: 1, name: 'Ahorro', type: 'saving', value: 0),
  ];

  Planning({
    required this.id,
    required this.planningIncome,
    List<PlanningItem>? planningItems,
  }) {
    if (planningItems != null) {
      this.planningItems.addAll(planningItems);
    }
  }

  // Factory method to create Planning object from JSON
  factory Planning.fromJson(Map<String, dynamic> json) {
    return Planning(
      id: json['id'],
      planningIncome: json['planningIncome'],
      planningItems: (json['planningItems'] as List)
          .map((planningItem) => PlanningItem.fromJson(planningItem))
          .toList(),
    );
  }

  // Method to convert Planning object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planningIncome': planningIncome,
      'planningItems':
          planningItems.map((planningItem) => planningItem.toJson()).toList(),
    };
  }

  // Method to add a new PlanningItem to the list
  void addPlanningItem(String name, String type, int value) {
    planningItems.add(PlanningItem(
      id: planningItems.length + 1,
      name: name,
      type: type,
      value: value,
    ));
  }

  // Method to remove a PlanningItem from the list
  void removePlanningItem(int id) {
    planningItems.removeWhere((planningItem) => planningItem.id == id);
  }

  // Method to update the value of a PlanningItem
  void updatePlanningItemValue(int id, int value) {
    final planningItem =
        planningItems.firstWhere((planningItem) => planningItem.id == id);
    planningItem.updateValue(value);
  }

  // Method to get the list of PlanningItems with {name, percentageValue, fixedValue}
  List<Map<String, dynamic>> getPlanningItems() {
    return planningItems
        .map((planningItem) => {
              'name': planningItem.name,
              'percentageValue': planningItem.type == 'percentage'
                  ? planningItem.value
                  : planningItem.value / planningIncome * 100,
              'fixedValue': planningItem.type == 'fixed'
                  ? planningItem.value
                  : planningItem.value * planningIncome / 100,
            })
        .toList();
  }
}

class PlanningItem {
  final int id;
  final String name;
  final String type; // "percentage" or "fixed"
  int value;

  PlanningItem({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
  });

  // Factory method to create PlanningItem object from JSON
  factory PlanningItem.fromJson(Map<String, dynamic> json) {
    return PlanningItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      value: json['value'],
    );
  }

  // Method to convert PlanningItem object to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'value': value,
      };

  // Method to update the value of a PlanningItem
  void updateValue(int value) {
    this.value = value;
  }
}
