import 'package:splitt/features/group/data/models/group_dashboard_model.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class GroupDashboard {
  final String balanceType;
  final double totalBalance;
  final List<GroupBalance> groups;
  final String description;

  GroupDashboard({
    required this.balanceType,
    required this.totalBalance,
    required this.groups,
    required this.description,
  });

  factory GroupDashboard.fromGroupDashboardModel(GroupDashboardModel model) {
    return GroupDashboard(
      balanceType: model.balanceType,
      totalBalance: model.totalBalance,
      groups: (model.groups)
          .map((g) => GroupBalance.fromGroupBalanceModel(g))
          .toList(),
      description: model.description,
    );
  }
}

class GroupBalance {
  final List<MemberBalance> memberBalances;
  final String balanceType;
  final double totalBalance;
  final String description;
  final Group group;

  GroupBalance({
    required this.memberBalances,
    required this.balanceType,
    required this.totalBalance,
    required this.description,
    required this.group,
  });

  factory GroupBalance.fromGroupBalanceModel(GroupBalanceModel model) {
    return GroupBalance(
      memberBalances: (model.memberBalances)
          .map((m) => MemberBalance.fromMemberBalanceModel(m))
          .toList(),
      balanceType: model.balanceType,
      totalBalance: model.totalBalance,
      description: model.description,
      group: Group.fromGroupModel(model.group),
    );
  }
}

class MemberBalance {
  final String balanceType;
  final double balance;
  final String description;
  final User user;

  MemberBalance({
    required this.balanceType,
    required this.balance,
    required this.description,
    required this.user,
  });

  factory MemberBalance.fromMemberBalanceModel(MemberBalanceModel model) {
    return MemberBalance(
      balanceType: model.balanceType,
      balance: model.balance,
      description: model.description,
      user: User.fromUserModel(model.user),
    );
  }
}
