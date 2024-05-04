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
  List<Transaction> transactions = [];
  List<Planning> plannings = [];

  User(
      {this.id,
      required this.name,
      required this.email,
      this.password,
      List<Account>? accounts,
      List<Transaction>? transactions,
      List<Planning>? plannings}) {
    if (accounts != null) {
      this.accounts.addAll(accounts);
    }
    if (transactions != null) {
      this.transactions.addAll(transactions);
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
      accounts: (json['accounts'] as List)
          .map((account) => Account.fromJson(account))
          .toList(),
      transactions: (json['transactions'] as List)
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
        'transactions':
            transactions.map((transaction) => transaction.toJson()).toList(),
        'plannings': plannings.map((planning) => planning.toJson()).toList(),
      };

  /// Method to add an account to the user's list of accounts.
  void addAccount(String name, int balance, String type) {
    int id = 0;
    accounts.forEach((account) {
      if (account.id >= id) {
        id = account.id + 1;
      }
    });
    AccountType typeAccount = type == 'Ahorro'
        ? AccountType.savings
        : type == 'Corriente'
            ? AccountType.current
            : AccountType.credit;
    final account = Account(
      id: id,
      name: name,
      type: typeAccount,
    );
    accounts.add(account);
    int transactionId = 0;
    transactions.forEach((transaction) {
      if (transaction.id >= transactionId) {
        transactionId = transaction.id + 1;
      }
    });
    final transaction = Transaction(
      id: transactionId,
      title: 'Saldo inicial',
      amount: balance,
      toAccountID: account.id,
      fromAccountID: -1,
    );
    transactions.add(transaction);
  }

  /// Method to add a transaction to the user's list of income transactions.
  void addIncome(String title, int amount, DateTime date, Account toAccount) {
    int id = 0;
    transactions.forEach((transaction) {
      if (transaction.id >= id) {
        id = transaction.id + 1;
      }
    });
    final transaction = Transaction(
      id: id,
      title: title,
      amount: amount,
      date: date,
      toAccountID: toAccount.id,
      fromAccountID: -1,
    );
    transactions.add(transaction);
  }

  /// Method to add a planning to the user's list of plannings. if exists a planning for the given month, it is not added.
  /// if exists a planning for the before month, create a new planning for the given month with the same values.
  void addPlanning(DateTime date) {
    String planningId = "${date.month}-${date.year}";
    for (Planning plan in plannings) {
      if (plan.id == planningId) {
        return;
      }
    }
    String beforePlanningId = "${date.month - 1}-${date.year}";
    for (Planning plan in plannings) {
      if (plan.id == beforePlanningId) {
        Planning newPlan = Planning(id: planningId, planningIncome: plan.planningIncome);
        for (PlanningItem item in plan.planningItems) {
          newPlan.addPlanningItem(item.name, item.type, item.value);
        }
        plannings.add(newPlan);
        return;
      }
    }
    Planning newPlan = Planning(id: planningId, planningIncome: 0);
    plannings.add(newPlan);
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
    for (Transaction transaction in transactions) {
      if (transaction.date != null &&
          transaction.date!.month == date.month &&
          transaction.date!.year == date.year &&
          transaction.type == 'income') {
        totalIncome += transaction.amount;
      }
    }
    return totalIncome;
  }

  // Method to add a transaction to the Account with the given ID.
  void addTransaction(String title, int amount, DateTime date,
      Account fromAccount, Account toAccount, String type) {
    int id = 0;
    transactions.forEach((transaction) {
      if (transaction.id >= id) {
        id = transaction.id + 1;
      }
    });
    final transaction = Transaction(
      id: id,
      title: title,
      amount: amount,
      date: date,
      toAccountID: toAccount.id,
      fromAccountID: fromAccount.id,
      type: type,
    );
    transactions.add(transaction);
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
    transactions.clear();
    transactions.addAll((json['income'] as List)
        .map((transaction) => Transaction.fromJson(transaction))
        .toList());
  }

  int getBalance() {
    int balance = 0;
    for (Account account in accounts) {
      balance += account.getBalance(transactions);
    }
    return balance;
  }

  int getSaveBalance() {
    int balance = 0;
    for (Account account in accounts) {
      if (account.type == 'savings') {
        balance += account.getBalance(transactions);
      }
    }
    return balance;
  }

  List<Transaction> getTransactionsByMonth(DateTime date) {
    List<Transaction> transactions = [];
    for (Transaction transaction in this.transactions) {
      if (transaction.date != null &&
          transaction.date!.month == date.month &&
          transaction.date!.year == date.year) {
        transactions.add(transaction);
      }
    }
    return transactions;
  }

  /// Method to get the total mount of the user's transactions for the given month.
  int getAmountOfTransactionsByMonth(DateTime date) {
    int total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.date != null &&
          transaction.date!.month == date.month &&
          transaction.date!.year == date.year) {
        if (transaction.toAccountID != -1) {
          total += transaction.amount;
        } else if (transaction.fromAccountID != -1) {
          total -= transaction.amount;
        }
      }
    }
    return total;
  }

  /// Method to get the total mount of the user's transactions for the given month
  int getTotalTransactionsByMonthAndType(DateTime date, String type) {
    int total = 0;
    for (Transaction transaction in transactions) {
      if (transaction.date != null &&
          transaction.date!.month == date.month &&
          transaction.date!.year == date.year &&
          transaction.type == type) {
        total += transaction.amount;
      }
    }
    return total;
  }

  /// Method to get the planning of the user for the given month.
  /// If the planning does not exist, it is created.
  /// The planning is returned as a list of maps with the following
  /// keys: name, planningPercentage, planningValue, realValue, realPercentage,
  /// expense, difference.
  List<PlanningItem> getPlanningByMonth(DateTime date) {
    String planningId = "${date.month}-${date.year}";
    List<PlanningItem> planningItems = [];
    for (Planning plan in plannings) {
      if (plan.id == planningId) {
        planningItems = plan.planningItems;
      }
    }
    return planningItems;
  }

  /// Method to show the planning of the user for the given month.
  /// If the planning does not exist, it is created.
  /// The planning is returned as a list of maps with the following
  /// keys: name, planningPercentage, planningValue, realValue, realPercentage,
  /// expense, difference.
  List<Map<String, dynamic>> showPlanningByMonth(DateTime date) {
    String planningId = "${date.month}-${date.year}";
    for (Planning plan in plannings) {
      if (plan.id == planningId) {
        List<PlanningItem> planningItems = plan.planningItems;
        List<Map<String, dynamic>> planning = [];
        int totalRealValue = getIncomesByMonth(date);
        print(totalRealValue);
        for (PlanningItem item in planningItems) {
          planning.add({
            'id': item.id,
            'type': item.type,
            'name': item.name,
            'planningPercentage': item.type == 'percentage'
                ? item.value
                : plan.planningIncome == 0
                    ? 0
                    : ((item.value * 10000) / plan.planningIncome).round() /
                        100,
            'planningValue': item.type == 'percentage'
                ? ((item.value * plan.planningIncome) / 100).round()
                : item.value,
            'realValue': item.type == 'percentage'
                ? ((item.value * totalRealValue) / 100).round()
                : item.value,
            'realPercentage': item.type == 'percentage'
                ? item.value
                : totalRealValue == 0
                    ? 0
                    : ((item.value * 10000) / totalRealValue).round() / 100,
            'expense': getTotalTransactionsByMonthAndType(date, item.name),
            'difference': item.type == 'percentage'
                ? (item.value * totalRealValue) / 100 -
                    getTotalTransactionsByMonthAndType(date, item.name)
                : item.value -
                    getTotalTransactionsByMonthAndType(date, item.name),
          });
        }
        int realValue = planning.fold(
            0,
            (previousValue, element) =>
                previousValue + int.parse(element['realValue'].toString()));

        planning.add(
          {
            'id': -1,
            'type': 'percentage',
            'name': 'Ahorro',
            'planningPercentage': ((100 -
                            planning.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    element['planningPercentage'])) *
                        100)
                    .round() /
                100,
            'planningValue': plan.planningIncome -
                planning.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element['planningValue']),
            'realValue': totalRealValue - realValue,
            'realPercentage': ((100 -
                            planning.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    element['realPercentage'])) *
                        100)
                    .round() /
                100,
            'expense': getTotalTransactionsByMonthAndType(date, 'Ahorro'),
            'difference': totalRealValue - realValue - getTotalTransactionsByMonthAndType(date, 'Ahorro'),
          },
        );
        int totalExpense = 0;
        for (Map<String, dynamic> item in planning) {
          totalExpense += int.parse(item['expense'].toString());
        }
        planning.add(
          {
            'id': -2,
            'type': 'percentage',
            'name': 'Total',
            'planningPercentage': 100,
            'planningValue': plan.planningIncome,
            'realValue': totalRealValue,
            'realPercentage': 100,
            'expense': totalExpense,
            'difference': totalRealValue - totalExpense,
          },
        );
        return planning;
      }
    }
    addPlanning(date);
    return showPlanningByMonth(date);
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

  void updatePlanningItem(DateTime time, int id, String name, String type,
      int percentage, int amount) {
    String planningId = "${time.month}-${time.year}";
    Planning planning = plannings.firstWhere((plan) => plan.id == planningId);
    PlanningItem planningItem =
        planning.planningItems.firstWhere((item) => item.id == id);
    String oldName = planningItem.name;
    planning.updatePlanningItem(id, name, type, percentage, amount);
    // actualizar el tipo de las transacciones
    if (oldName != name) {
      for (Transaction transaction in transactions) {
        if (transaction.type == oldName) {
          transaction.updateType(name);
        }
      }
    }
  }

  void update(String newName, String newEmail, String newPassword) {
    name = newName;
    email = newEmail;
    password = newPassword;
  }
}
