/// Model class to represent a Planning object
class Planning {
  final String id;
  int planningIncome;
  List<PlanningItem> planningItems = [];

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
      id: planningItems.length,
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

  void updatePlanningItem(
      int id, String name, String type, int percentage, int amount) {
    final planningItem =
        planningItems.firstWhere((planningItem) => planningItem.id == id);
    planningItem.update(name, type, percentage, amount);
  }

  // Method to get the list of PlanningItems
  List<PlanningItem> getPlanningItems() {
    return planningItems;
  }
}

class PlanningItem {
  final int id;
  String name;
  String type; // "percentage" or "fixed"
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

  void update(String newName, String newType, int newPercentage, int newAmount) {
    print('update $name $type $value');
    print('to $newName $newType $newPercentage $newAmount');
    name = newName;
    type = newType;
    value = newType == 'percentage' ? newPercentage : newAmount;

  }

  String getName(){
    return name;
  }
}
