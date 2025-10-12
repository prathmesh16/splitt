import 'package:flutter/material.dart';
import 'package:splitt/common/models/user.dart';
import 'package:splitt/features/split/models/spilt_type.dart';

class Expense extends ChangeNotifier {
  final List<User> users;
  late SplitType _splitType;
  double _amount = 0;
  late final List<String> _selectedUsers;
  final Map<String, double> _amounts = {};
  final Map<String, double> _percentages = {};
  final Map<String, double> _shares = {};
  final Map<String, double> _adjustments = {};

  final Map<String, double> _paidBy = {};
  final User me = const User(
    id: "1",
    name: "Prathmesh",
  );

  Expense({
    required this.users,
    double amount = 0,
  }) {
    _splitType = SplitType.equal;
    _selectedUsers = users.map((user) => user.id).toList();
    for (var user in users) {
      _shares[user.id] = 1;
    }
    _amount = amount;
    _paidBy[me.id] = amount;
  }

  set amount(double amount) {
    _amount = amount;
    _paidBy[me.id] = amount;
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
    if (_paidBy[me.id] != null) {
      return "you";
    }
    for (final paidBy in _paidBy.keys) {
      return users.firstWhere((user) => user.id == paidBy).name;
    }
    return "";
  }

  set splitType(SplitType splitType) {
    _splitType = splitType;
    notifyListeners();
  }

  SplitType get splitType => _splitType;

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

  String get formattedEqualSplit =>
      (amount / selectedUsersLength).toStringAsFixed(2);

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

  String? getUserShare(String userId) {
    return _shares[userId]?.toStringAsFixed(0);
  }

  String? getUserShareAmount(String userId) {
    return (((_shares[userId] ?? 0) * amount) / totalSharesNum)
        .toStringAsFixed(2);
  }

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

  String? getUserAdjustment(String userId) {
    return _adjustments[userId]?.toStringAsFixed(2);
  }

  String? getUserAdjustmentTotalAmount(String userId) {
    final totalAdjustments = _adjustments.isNotEmpty
        ? _adjustments.values.reduce((a, b) => a + b)
        : 0;
    return (((amount - totalAdjustments) / users.length) +
            (_adjustments[userId] ?? 0))
        .toStringAsFixed(2);
  }

  void setAdjustment(String userId, double? adjustment) {
    if (adjustment == null) {
      _adjustments.remove(userId);
    } else {
      _adjustments[userId] = adjustment;
    }
    notifyListeners();
  }
}
