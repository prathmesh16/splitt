import 'package:splitt/features/friends/data/models/friends_dashboard_model.dart';

class FriendsDashboard {
  final String balanceType;
  final double totalBalance;
  final List<UserBalance> users;
  final String description;

  FriendsDashboard({
    required this.balanceType,
    required this.totalBalance,
    required this.users,
    required this.description,
  });

  factory FriendsDashboard.fromFriendsDashboardModel(
    FriendsDashboardModel model,
  ) {
    return FriendsDashboard(
      balanceType: model.balanceType,
      totalBalance: model.totalBalance,
      users: (model.users)
          .map((u) => UserBalance.fromUserBalanceModel(u))
          .toList(),
      description: model.description,
    );
  }
}

class UserBalance {
  final List<Transaction> transactions;
  final String balanceType;
  final double totalBalance;
  final String name;
  final String userId;

  UserBalance({
    required this.transactions,
    required this.balanceType,
    required this.totalBalance,
    required this.name,
    required this.userId,
  });

  factory UserBalance.fromUserBalanceModel(UserBalanceModel model) {
    return UserBalance(
      transactions: (model.transactions)
          .map((m) => Transaction.fromTransactionModel(m))
          .toList(),
      balanceType: model.balanceType,
      totalBalance: model.totalBalance,
      name: model.name,
      userId: model.userId,
    );
  }
}

class Transaction {
  final String balanceType;
  final double balance;
  final String name;
  final String type;

  Transaction({
    required this.balanceType,
    required this.balance,
    required this.name,
    required this.type,
  });

  factory Transaction.fromTransactionModel(TransactionModel model) {
    return Transaction(
      balanceType: model.balanceType,
      balance: model.balance,
      name: model.name,
      type: model.type,
    );
  }
}
