import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splitt/common/utils/utils.dart';
import 'package:splitt/features/expense/data/models/expense_model.dart';
import 'package:splitt/features/group/domain/group_users_data_store.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/features/split/models/spilt_type.dart';

class Expense extends ChangeNotifier {
  String? id;
  final List<User> users;
  late SplitType _splitType;
  String name = "";
  double _amount = 0;
  late final List<String> _selectedUsers;
  Map<String, double> _amounts = {};
  Map<String, double> _percentages = {};
  Map<String, double> _shares = {};
  Map<String, double> _adjustments = {};

  Map<String, double> _paidBy = {};
  final User me = UserDataStore().me!;
  final String myUserId = UserDataStore().userId;
  late final DateTime date;
  final String groupId;
  final User createdBy = UserDataStore().me!;

  final bool isSettleUp;

  Expense({
    required this.users,
    required this.groupId,
    this.id,
    double amount = 0,
    List<String>? selectedUsers,
    this.isSettleUp = false,
  }) {
    _splitType = SplitType.equal;
    _selectedUsers = selectedUsers ?? users.map((user) => user.id).toList();
    for (var user in users) {
      _shares[user.id] = 1;
    }
    _amount = amount;
    _paidBy[myUserId] = amount;
    date = DateTime.now();
  }

  set amount(double amount) {
    _amount = amount;
    for (final paidBy in _paidBy.keys) {
      _paidBy[paidBy] = amount;
      break;
    }
    notifyListeners();
  }

  double get amount => _amount;

  int get paidByLength => _paidBy.length;

  bool isUserPaid(String userId) {
    return _paidBy.containsKey(userId);
  }

  void setPaidBy(String userId) {
    _paidBy.clear();
    _paidBy[userId] = amount;
    notifyListeners();
  }

  String getPaidBy() {
    if (_paidBy[myUserId] != null) {
      return "you";
    }
    for (final paidBy in _paidBy.keys) {
      return users.firstWhere((user) => user.id == paidBy).name;
    }
    return "";
  }

  String getPaidByID() {
    if (_paidBy[myUserId] != null) {
      return myUserId;
    }
    for (final paidBy in _paidBy.keys) {
      return paidBy;
    }
    return "";
  }

  String getPaidAmount() {
    for (final paidValue in _paidBy.values) {
      return paidValue.toStringAsFixed(2);
    }
    return "";
  }

  double getBorrowedAmount({String? id}) {
    switch (_splitType) {
      case SplitType.equal:
        return isUserSelected(id ?? myUserId) ? equalSpilt : 0;
      case SplitType.amount:
        return _amounts[id ?? myUserId] ?? 0;
      case SplitType.percentage:
        return amount * (_percentages[id ?? myUserId] ?? 0) / 100;
      case SplitType.share:
        return getUserShareAmount(id ?? myUserId);
      case SplitType.adjustment:
        return getUserAdjustmentTotalAmount(id ?? myUserId);
    }
  }

  String getFormattedBorrowedAmount({String? id}) =>
      getBorrowedAmount(id: id).abs().toStringAsFixed(2);

  double getRemainingAmount({String? id}) =>
      (_paidBy[id ?? myUserId] ?? 0) - getBorrowedAmount(id: id);

  String getFormattedRemainingAmount({String? id}) =>
      getRemainingAmount(id: id).abs().toStringAsFixed(2);

  set splitType(SplitType splitType) {
    _splitType = splitType;
    notifyListeners();
  }

  SplitType get splitType => _splitType;

  List<String> get selectedUsers => _selectedUsers;

  void selectUser(String userId) {
    _selectedUsers.add(userId);
    notifyListeners();
  }

  void selectAllUsers(List<User> users) {
    _selectedUsers.clear();
    _selectedUsers.addAll(users.map((user) => user.id));
    notifyListeners();
  }

  void removeUser(String userId) {
    _selectedUsers.remove(userId);
    notifyListeners();
  }

  void removeAllUsers() {
    _selectedUsers.clear();
    notifyListeners();
  }

  bool isUserSelected(String userId) {
    return _selectedUsers.contains(userId);
  }

  int get selectedUsersLength => _selectedUsers.length;

  double get equalSpilt => (amount / selectedUsersLength);

  String get formattedEqualSplit => equalSpilt.toStringAsFixed(2);

  Map<String, double> get amounts => _amounts;

  String? getUserAmount(String userId) {
    return _amounts[userId]?.toStringAsFixed(2);
  }

  void setAmount(String userId, double? amount) {
    if (amount == null) {
      _amounts.remove(userId);
    } else {
      _amounts[userId] = amount;
    }
    notifyListeners();
  }

  String get addedAmount => _amounts.values.isNotEmpty
      ? _amounts.values.reduce((a, b) => a + b).toStringAsFixed(2)
      : "0.00";

  String get remainingAmount => _amounts.values.isNotEmpty
      ? (amount - _amounts.values.reduce((a, b) => a + b)).toStringAsFixed(2)
      : amount.toStringAsFixed(2);

  Map<String, double> get percentages => _percentages;

  String? getUserPercentage(String userId) {
    return _percentages[userId]?.toStringAsFixed(2);
  }

  void setPercentage(String userId, double? percentage) {
    if (percentage == null) {
      _percentages.remove(userId);
    } else {
      _percentages[userId] = percentage;
    }
    notifyListeners();
  }

  String get addedPercentage => _percentages.values.isNotEmpty
      ? _percentages.values.reduce((a, b) => a + b).toStringAsFixed(2)
      : "0.00";

  String get remainingPercentage => _percentages.values.isNotEmpty
      ? (100 - _percentages.values.reduce((a, b) => a + b)).toStringAsFixed(2)
      : 100.toStringAsFixed(2);

  Map<String, double> get shares => _shares;

  String? getUserShare(String userId) {
    return _shares[userId]?.toStringAsFixed(0);
  }

  double getUserShareAmount(String userId) =>
      (((_shares[userId] ?? 0) * amount) / totalSharesNum);

  String? getFormattedUserShareAmount(String userId) =>
      getUserShareAmount(userId).toStringAsFixed(2);

  void setShare(String userId, double? share) {
    if (share == null) {
      _shares.remove(userId);
    } else {
      _shares[userId] = share;
    }
    notifyListeners();
  }

  double get totalSharesNum =>
      _shares.values.isNotEmpty ? (_shares.values.reduce((a, b) => a + b)) : 0;

  String get totalShares => totalSharesNum.toStringAsFixed(0);

  Map<String, double> get adjustments => _adjustments;

  String? getUserAdjustment(String userId) {
    return _adjustments[userId]?.toStringAsFixed(2);
  }

  double getUserAdjustmentTotalAmount(String userId) {
    final totalAdjustments = _adjustments.isNotEmpty
        ? _adjustments.values.reduce((a, b) => a + b)
        : 0;
    return (((amount - totalAdjustments) / users.length) +
        (_adjustments[userId] ?? 0));
  }

  String? getFormattedUserAdjustmentTotalAmount(String userId) =>
      getUserAdjustmentTotalAmount(userId).toStringAsFixed(2);

  void setAdjustment(String userId, double? adjustment) {
    if (adjustment == null) {
      _adjustments.remove(userId);
    } else {
      _adjustments[userId] = adjustment;
    }
    notifyListeners();
  }

  List<String> getIncludedIds() {
    final expense = this;
    final List<String> ids = [];
    switch (expense.splitType) {
      case SplitType.equal:
        ids.addAll(expense.selectedUsers);
      case SplitType.amount:
        expense.amounts.forEach((id, amount) {
          if (amount != 0) {
            ids.add(id);
          }
        });
      case SplitType.percentage:
        expense.percentages.forEach((id, amount) {
          if (amount != 0) {
            ids.add(id);
          }
        });
      case SplitType.share:
        expense.shares.forEach((id, amount) {
          if (amount != 0) {
            ids.add(id);
          }
        });
      case SplitType.adjustment:
        for (final user in expense.users) {
          if (expense.getUserAdjustmentTotalAmount(user.id) != 0) {
            ids.add(user.id);
          }
        }
    }
    return ids;
  }

  Map<String, dynamic> getSplitDetails() {
    switch (_splitType) {
      case SplitType.equal:
        return {};
      case SplitType.amount:
        return {"amounts": amounts};
      case SplitType.percentage:
        return {"percentages": percentages};
      case SplitType.share:
        return {"shares": shares};
      case SplitType.adjustment:
        return {"adjustments": adjustments};
    }
  }

  void _setSplitDetails(ExpenseModel expenseModel) {
    switch (expenseModel.splitType) {
      case SplitType.amount:
        _amounts = Utils.convertMapValuesToType<double>(
            expenseModel.splitDetails["amounts"] ?? {});
      case SplitType.percentage:
        _percentages = Utils.convertMapValuesToType<double>(
            expenseModel.splitDetails["percentages"] ?? {});
      case SplitType.share:
        _shares = Utils.convertMapValuesToType<double>(
            expenseModel.splitDetails["shares"] ?? {});
      case SplitType.adjustment:
        _adjustments = Utils.convertMapValuesToType<double>(
            expenseModel.splitDetails["adjustments"] ?? {});
      case SplitType.equal:
        return;
    }
  }

  factory Expense.fromExpenseModel(ExpenseModel expenseModel) {
    return Expense(
      id: expenseModel.id,
      users: GroupUsersDataStore().users,
      groupId: expenseModel.groupId,
      amount: expenseModel.amount,
      selectedUsers: expenseModel.participantIds,
      isSettleUp: expenseModel.isSettleUp,
    )
      ..name = expenseModel.title
      .._paidBy = {expenseModel.payerId: expenseModel.amount}
      ..splitType = expenseModel.splitType
      .._setSplitDetails(expenseModel);
  }

  String getFormattedDate([String format = "dd MMMM yyyy"]) {
    return DateFormat(format).format(date);
  }

  String getFormattedAmount() {
    return amount.toStringAsFixed(2);
  }

  Expense copy() {
    return Expense(
      id: id,
      users: GroupUsersDataStore().users,
      groupId: groupId,
      amount: amount,
      selectedUsers: selectedUsers.toList(),
      isSettleUp: isSettleUp,
    )
      ..name = name
      .._paidBy.clear()
      .._paidBy.addAll(_paidBy)
      ..splitType = splitType
      .._amounts.addAll(_amounts)
      .._percentages.addAll(_percentages)
      .._shares.addAll(_shares)
      .._adjustments.addAll(_adjustments);
  }

  void updateExpense(Expense expense) {
    _selectedUsers.clear();
    _selectedUsers.addAll(expense.selectedUsers);
    name = expense.name;
    _amount = expense.amount;
    _paidBy = expense._paidBy;
    splitType = expense.splitType;
    _amounts = expense._amounts;
    _percentages = expense._percentages;
    _shares = expense._shares;
    _adjustments = expense._adjustments;
  }

  String getSettledToUser() {
    final includedIds = getIncludedIds();
    for (final id in includedIds) {
      if (id == myUserId) {
        return "you";
      }
      return users.firstWhere((user) => user.id == id).name;
    }
    return "";
  }

  User? getSettlementUser() {
    for (final paidBy in _paidBy.keys) {
      if (paidBy != myUserId) {
        return GroupUsersDataStore().getUser(paidBy)!;
      }
    }
    final includedIds = getIncludedIds();
    for (final id in includedIds) {
      return users.firstWhere((user) => user.id == id);
    }
    return null;
  }
}
