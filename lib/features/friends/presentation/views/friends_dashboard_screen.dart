import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/currency_amount.dart';
import 'package:splitt/common/custom_refresh_indicator.dart';
import 'package:splitt/common/hierarchy_widget.dart';
import 'package:splitt/features/friends/presentation/bloc/friends_dashboard_bloc.dart';
import 'package:splitt/features/friends/presentation/models/friends_dashboard.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/presentation/views/groups_dashboard_shimmer.dart';
import 'package:splitt/theme/theme_extension.dart';

class FriendsDashboardScreen extends StatefulWidget {
  const FriendsDashboardScreen({super.key});

  @override
  State<FriendsDashboardScreen> createState() => _FriendsDashboardScreenState();
}

class _FriendsDashboardScreenState extends State<FriendsDashboardScreen> {
  late final FriendsDashboardBloc friendsDashboardBloc;

  @override
  void initState() {
    super.initState();
    friendsDashboardBloc = context.read<FriendsDashboardBloc>();
    friendsDashboardBloc.getFriendsDashboard();
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
                      //TODO : add Add friends action
                    },
                    child: Text(
                      "Add friends",
                      style: context.f.body2.copyWith(
                        color: context.c.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: BlocProvider.value(
                value: friendsDashboardBloc,
                child: BlocBuilder<FriendsDashboardBloc,
                    UIState<FriendsDashboard>>(
                  bloc: friendsDashboardBloc,
                  builder: (_, UIState state) {
                    if (friendsDashboardBloc.dashboard != null) {
                      return _GroupsList(
                        friendsDashboard: friendsDashboardBloc.dashboard!,
                        onDone: () {
                          friendsDashboardBloc.getFriendsDashboard();
                        },
                      );
                    }
                    return const GroupsDashboardShimmer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupsList extends StatefulWidget {
  final FriendsDashboard friendsDashboard;
  final VoidCallback? onDone;

  const _GroupsList({
    required this.friendsDashboard,
    this.onDone,
  });

  @override
  State<_GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<_GroupsList> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      controller: scrollController,
      onRefresh: context.read<FriendsDashboardBloc>().getFriendsDashboard,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      widget.friendsDashboard.totalBalance > 0
                          ? "Overall, you are owed "
                          : widget.friendsDashboard.totalBalance < 0
                              ? "Overall, you owes "
                              : "You are all settled up",
                      style: context.f.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.friendsDashboard.totalBalance != 0)
                      CurrencyAmount(
                        amount: widget.friendsDashboard.totalBalance
                            .abs()
                            .toStringAsFixed(2),
                        style: context.f.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          color: widget.friendsDashboard.totalBalance > 0
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
            ),
          ),
          SliverList.builder(
            itemBuilder: (_, index) {
              return _UserTile(
                user: widget.friendsDashboard.users[index],
                onDOne: widget.onDone,
              );
            },
            itemCount: widget.friendsDashboard.users.length,
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserBalance user;
  final VoidCallback? onDOne;

  const _UserTile({
    super.key,
    required this.user,
    this.onDOne,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //TODO : add User details tap action
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
              Avatar(
                seed: user.name,
                size: 54,
              ),
              const SizedBox(width: 16),
              Text(
                user.name,
                style: context.f.body1,
              ),
              const Spacer(),
              if (user.totalBalance == 0)
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
                      user.totalBalance > 0 ? "owes you" : "you owe",
                      style: context.f.body1.copyWith(
                        fontSize: 10,
                        color: user.totalBalance > 0
                            ? context.c.primaryColor
                            : context.c.secondaryColor,
                      ),
                    ),
                    CurrencyAmount(
                      amount: user.totalBalance.abs().toStringAsFixed(2),
                      style: context.f.body1.copyWith(
                        color: user.totalBalance > 0
                            ? context.c.primaryColor
                            : context.c.secondaryColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          children: user.transactions
              //TODO : remove this once backend removes 0 balance entries
              .where((transaction) => transaction.balance != 0)
              .map((transaction) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.balance > 0
                              ? "${user.name} owes you "
                              : "You owe ${user.name} ",
                          style: context.f.body3.copyWith(
                            color: context.c.secondaryTextColor,
                          ),
                        ),
                        CurrencyAmount(
                          amount: transaction.balance.abs().toStringAsFixed(2),
                          style: context.f.body3.copyWith(
                            color: transaction.balance > 0
                                ? context.c.primaryColor
                                : context.c.secondaryColor,
                          ),
                        ),
                        Text(
                          " in \"${transaction.name}\"",
                          style: context.f.body3.copyWith(
                            color: context.c.secondaryTextColor,
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
