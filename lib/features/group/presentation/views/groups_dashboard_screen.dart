import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/currency_amount.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/hierarchy_widget.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/features/group/presentation/bloc/group_dashboard_bloc.dart';
import 'package:splitt/features/group/presentation/bloc/groups_bloc.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/presentation/models/group_dashboard.dart';
import 'package:splitt/features/group/presentation/views/create_group_screen.dart';
import 'package:splitt/features/group/presentation/views/group_details.dart';
import 'package:splitt/theme/theme_extension.dart';

class GroupDashboardScreen extends StatefulWidget {
  const GroupDashboardScreen({super.key});

  @override
  State<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen> {
  late final GroupDashboardBloc groupDashboardBloc;

  @override
  void initState() {
    super.initState();
    groupDashboardBloc = GroupDashboardBloc();
    groupDashboardBloc.getGroupDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      final res = await Navigator.push(
                        context,
                        slideFromBottom(const CreateGroupScreen()),
                      );
                      if (res == true) {
                        groupDashboardBloc.getGroupDashboard();
                      }
                    },
                    child: Text(
                      "Create group",
                      style: context.f.body2.copyWith(
                        color: context.c.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocProvider(
              create: (_) => groupDashboardBloc,
              child: BlocBuilder<GroupDashboardBloc, UIState<GroupDashboard>>(
                bloc: groupDashboardBloc,
                builder: (_, UIState state) {
                  if (state is Success<GroupDashboard>) {
                    return _GroupsList(groupDashboard: state.data);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  final GroupDashboard groupDashboard;

  const _GroupsList({
    required this.groupDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    groupDashboard.totalBalance > 0
                        ? "Overall, you are owed "
                        : groupDashboard.totalBalance < 0
                            ? "Overall, you owes "
                            : "You are all settled up",
                    style: context.f.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (groupDashboard.totalBalance != 0)
                    CurrencyAmount(
                      amount:
                          groupDashboard.totalBalance.abs().toStringAsFixed(2),
                    style: context.f.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: groupDashboard.totalBalance > 0
                          ? context.c.primaryColor
                          : context.c.secondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.filter_list_rounded,
                    color: context.c.secondaryTextColor,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupDashboard.groups.length,
              itemBuilder: (_, index) {
                return _GroupTile(
                  group: groupDashboard.groups[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final GroupBalance group;

  const _GroupTile({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final res = await Navigator.push(
          context,
          slideFromRight(
            GroupDetails(
              group: group.group,
            ),
          ),
        );
        if (res == true) {}
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 8,
          top: 8,
          bottom: 8,
        ),
        child: HierarchyWidget(
          childLeftPadding: 23.5,
          header: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset("assets/images/group_avatar.png"),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                group.group.name,
                style: context.f.body1,
              ),
              const Spacer(),
              if (group.totalBalance == 0)
                Text(
                  "settled up",
                  style: context.f.body3.copyWith(
                    fontSize: 10,
                    color: context.c.secondaryTextColor,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      group.totalBalance > 0 ? "you are owed" : "you owe",
                      style: context.f.body1.copyWith(
                        fontSize: 10,
                        color: group.totalBalance > 0
                            ? context.c.primaryColor
                            : context.c.secondaryColor,
                      ),
                    ),
                    CurrencyAmount(
                      amount: group.totalBalance.toStringAsFixed(2),
                      style: context.f.body1.copyWith(
                        color: group.totalBalance > 0
                            ? context.c.primaryColor
                            : context.c.secondaryColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          children: group.memberBalances
              //TODO : remove this once backend removes 0 balance entries
              .where((memberBalance) => memberBalance.balance != 0)
              .map((memberBalance) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memberBalance.balance > 0
                              ? "${memberBalance.user.name} owes you "
                              : "You owe ${memberBalance.user.name} ",
                          style: context.f.body3.copyWith(
                            color: context.c.secondaryTextColor,
                          ),
                        ),
                        CurrencyAmount(
                          amount: memberBalance.balance.toStringAsFixed(2),
                          style: context.f.body3.copyWith(
                            color: memberBalance.balance > 0
                                ? context.c.primaryColor
                                : context.c.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
