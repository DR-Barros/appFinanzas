import 'package:app_finanzas/models/account.dart';
import 'package:app_finanzas/models/planning.dart';
import 'package:app_finanzas/models/transaction.dart';

/// Class to represent a User.
/// A User has a name, email, password, list of accounts, list of income transactions,
/// and list of plannings.
class User {
  String? id;
  String name;
  String email;
  String? password;
  List<Account> accounts = [];
  List<Transaction> income = [];
  List<Planning> plannings = [];

  User(
      {this.id,
      required this.name,
      required this.email,
      this.password,
      List<Account>? accounts,
      List<Transaction>? income,
      List<Planning>? plannings}) {
    if (accounts != null) {
      this.accounts.addAll(accounts);
    }
    if (income != null) {
      this.income.addAll(income);
    }
    if (plannings != null) {
      this.plannings.addAll(plannings);
    } else {
      addPlanning(DateTime.now());
    }
  }

  /// Named constructor to create a User instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      accounts: (json['accounts'] as List).map((account) {
        return Account.fromJson(account);
      }).toList(),
      income: (json['income'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
      plannings: (json['plannings'] as List)
          .map((planning) => Planning.fromJson(planning))
          .toList(),
    );
  }

  /// Method to convert a User instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'accounts': accounts.map((account) => account.toJson()).toList(),
        'income': income.map((transaction) => transaction.toJson()).toList(),
        'plannings': plannings.map((planning) => planning.toJson()).toList(),
      };

  /// Method to add an account to the user's list of accounts.
  void addAccount(String name, int balance, String type) {
    String typeAccount = type == 'Ahorro' ? 'savings' : 'current';
    final account = Account(
      id: accounts.length,
      name: name,
      balance: balance,
      type: typeAccount,
    );
    accounts.add(account);
  }

  /// Method to add a transaction to the user's list of income transactions.
  void addIncome(String title, int amount, DateTime date, int toAccountID) {
    final transaction = Transaction(
      id: income.length.toString(),
      title: title,
      amount: amount,
      date: date,
      toAccountID: toAccountID,
    );
    income.add(transaction);
    final account = accounts.firstWhere((account) => account.id == toAccountID);
    account.addIncome(transaction);
  }

  /// Method to add a planning to the user's list of plannings.
  void addPlanning(DateTime date) {
    String planningId = "${date.month}-${date.year}";
    plannings
        .add(Planning(id: planningId, planningIncome: getIncomesByMonth(date)));
  }

  /// Method to edit the planning income of the user for the given month.
  void editPlanningIncome(DateTime date, int amount) {
    String planningId = "${date.month}-${date.year}";
    Planning planning = plannings.firstWhere((plan) => plan.id == planningId);
    planning.planningIncome = amount;
  }

  /// Method to add a planning item to the user's list of plannings.
  void addPlanningItem(
      String name, int amount, String type, int percentage, DateTime date) {
    String planningId = "${date.month}-${date.year}";
    Planning planning = plannings.firstWhere((plan) => plan.id == planningId);
    if (type == 'percentage') {
      planning.addPlanningItem(name, type, percentage);
    } else {
      planning.addPlanningItem(name, type, amount);
    }
  }

  // Method to get the total income of the user for the given month.
  int getIncomesByMonth(DateTime date) {
    int totalIncome = 0;
    for (Transaction transaction in income) {
      if (transaction.date.month == date.month &&
          transaction.date.year == date.year) {
        totalIncome += transaction.amount;
      }
    }
    return totalIncome;
  }

  // Method to add a transaction to the Account with the given ID.
  void addTransaction(String title, int amount, DateTime date,
      int fromAccountID, int toAccountID, String type) {
    final transaction = Transaction(
      id: income.length.toString(),
      title: title,
      amount: amount,
      date: date,
      toAccountID: toAccountID,
      type: type,
    );
    Account fromAccount =
        accounts.firstWhere((account) => account.id == fromAccountID);
    fromAccount.addTransaction(transaction);
    if (toAccountID != -1) {
      Account toAccount =
          accounts.firstWhere((account) => account.id == toAccountID);
      toAccount.addIncome(transaction);
    }
  }

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    accounts.clear();
    accounts.addAll((json['accounts'] as List)
        .map((account) => Account.fromJson(account))
        .toList());
    income.clear();
    income.addAll((json['income'] as List)
        .map((transaction) => Transaction.fromJson(transaction))
        .toList());
  }

  List<Transaction> getTransactionsByMonth(DateTime date) {
    List<Transaction> transactions = [];
    for (Account account in accounts) {
      transactions.addAll(account.getTransactionsByMonth(date));
    }
    return transactions;
  }

  /// Method to get the total mount of the user's transactions for the given month.
  int getTotalTransactionsByMonth(DateTime date) {
    int total = 0;
    for (Account account in accounts) {
      total += account.getTotalTransactionsByMonth(date);
    }
    return total;
  }

  /// Method to get the total mount of the user's transactions for the given month
  int getTotalTransactionsByMonthAndType(DateTime date, String type) {
    int total = 0;
    for (Account account in accounts) {
      total += account.getTotalTransactionsByMonthAndType(date, type);
    }
    return total;
  }

  /// Method to get the planning of the user for the given month.
  /// If the planning does not exist, it is created.
  /// The planning is returned as a list of maps with the following
  /// keys: name, planningPercentage, planningValue, realValue, realPercentage,
  /// expense, difference.
  List<Map<String, dynamic>> getPlanningByMonth(DateTime date) {
    String planningId = "${date.month}-${date.year}";
    for (Planning plan in plannings) {
      if (plan.id == planningId) {
        List<PlanningItem> planningItems = plan.planningItems;
        List<Map<String, dynamic>> planning = [];
        int totalRealValue = getIncomesByMonth(date);
        for (PlanningItem item in planningItems) {
          planning.add({
            'name': item.name,
            'planningPercentage': item.type == 'percentage'
                ? item.value
                : (item.value * 100) / plan.planningIncome,
            'planningValue': item.type == 'percentage'
                ? (item.value * plan.planningIncome) / 100
                : item.value,
            'realValue': item.type == 'percentage'
                ? (item.value * totalRealValue) / 100
                : item.value,
            'realPercentage': item.type == 'percentage'
                ? item.value
                : (item.value * 100) / totalRealValue,
            'expense': getTotalTransactionsByMonthAndType(date, item.name),
            'difference': item.type == 'percentage'
                ? item.value -
                    getTotalTransactionsByMonthAndType(date, item.name)
                : (item.value * 100) / totalRealValue -
                    getTotalTransactionsByMonthAndType(date, item.name),
          });
        }
        planning.add(
          {
            'name': 'Ahorro',
            'planningPercentage': 100 -
                planning.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element['planningPercentage']),
            'planningValue': plan.planningIncome -
                planning.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element['planningValue']),
            'realValue': totalRealValue -
                planning.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element['realValue']),
            'realPercentage': 100 -
                planning.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element['realPercentage']),
            'expense': totalRealValue - getTotalTransactionsByMonth(date),
            'difference': 0,
          },
        );
        planning.add(
          {
            'name': 'Total',
            'planningPercentage': 100,
            'planningValue': plan.planningIncome,
            'realValue': totalRealValue,
            'realPercentage': 100,
            'expense': getTotalTransactionsByMonth(date),
            'difference': totalRealValue - getTotalTransactionsByMonth(date),
          },
        );
        return planning;
      }
    }
    addPlanning(date);
    return getPlanningByMonth(date);
  }

  int getPlanningIncomeByMonth(DateTime date) {
    String planningId = "${date.month}-${date.year}";
    for (Planning plan in plannings) {
      if (plan.id == planningId) {
        return plan.planningIncome;
      }
    }
    return 0;
  }
}
