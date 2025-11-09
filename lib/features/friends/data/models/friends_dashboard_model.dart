import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/users/data/models/user_model.dart';

class FriendsDashboardModel {
  final String balanceType;
  final double totalBalance;
  final List<UserBalanceModel> users;
  final String description;

  FriendsDashboardModel({
    required this.balanceType,
    required this.totalBalance,
    required this.users,
    required this.description,
  });

  factory FriendsDashboardModel.fromJson(Map<String, dynamic> json) {
    return FriendsDashboardModel(
      balanceType: json['balanceType'] ?? '',
      totalBalance: (json['totalBalance'] ?? 0).toDouble(),
      users: (json['users'] as List<dynamic>? ?? [])
          .map((g) => UserBalanceModel.fromJson(g))
          .toList(),
      description: json['description'] ?? '',
    );
  }
}

class UserBalanceModel {
  final List<TransactionModel> transactions;
  final String balanceType;
  final double totalBalance;
  final String name;
  final String userId;

  UserBalanceModel({
    required this.transactions,
    required this.balanceType,
    required this.totalBalance,
    required this.name,
    required this.userId,
  });

  factory UserBalanceModel.fromJson(Map<String, dynamic> json) {
    return UserBalanceModel(
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((m) => TransactionModel.fromJson(m))
          .toList(),
      balanceType: json['balanceType'] ?? '',
      totalBalance: (json['totalBalance'] ?? 0).toDouble(),
      name: json['name'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}

class TransactionModel {
  final String balanceType;
  final double balance;
  final String name;
  final String type;

  TransactionModel({
    required this.balanceType,
    required this.balance,
    required this.name,
    required this.type,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
        balanceType: json['balanceType'] ?? '',
        balance: (json['balance'] ?? 0).toDouble(),
        name: json['name'] ?? '',
        type: json['type'] ?? '');
  }
}
