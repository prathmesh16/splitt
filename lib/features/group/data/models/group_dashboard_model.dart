import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/users/data/models/user_model.dart';

class GroupDashboardModel {
  final String balanceType;
  final double totalBalance;
  final List<GroupBalanceModel> groups;
  final String description;

  GroupDashboardModel({
    required this.balanceType,
    required this.totalBalance,
    required this.groups,
    required this.description,
  });

  factory GroupDashboardModel.fromJson(Map<String, dynamic> json) {
    return GroupDashboardModel(
      balanceType: json['balanceType'] ?? '',
      totalBalance: (json['totalBalance'] ?? 0).toDouble(),
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((g) => GroupBalanceModel.fromJson(g))
          .toList(),
      description: json['description'] ?? '',
    );
  }
}

class GroupBalanceModel {
  final List<MemberBalanceModel> memberBalances;
  final String balanceType;
  final double totalBalance;
  final String description;
  final GroupModel group;

  GroupBalanceModel({
    required this.memberBalances,
    required this.balanceType,
    required this.totalBalance,
    required this.description,
    required this.group,
  });

  factory GroupBalanceModel.fromJson(Map<String, dynamic> json) {
    return GroupBalanceModel(
      memberBalances: (json['memberBalances'] as List<dynamic>? ?? [])
          .map((m) => MemberBalanceModel.fromJson(m))
          .toList(),
      balanceType: json['balanceType'] ?? '',
      totalBalance: (json['totalBalance'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      group: GroupModel.fromJson(json['group'] ?? {}),
    );
  }
}

class MemberBalanceModel {
  final String balanceType;
  final double balance;
  final String description;
  final UserModel user;

  MemberBalanceModel({
    required this.balanceType,
    required this.balance,
    required this.description,
    required this.user,
  });

  factory MemberBalanceModel.fromJson(Map<String, dynamic> json) {
    return MemberBalanceModel(
      balanceType: json['balanceType'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
