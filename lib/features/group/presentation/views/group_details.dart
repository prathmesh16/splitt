import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:splitt/common/add_expense_button.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/currency_amount.dart';
import 'package:splitt/common/custom_refresh_indicator.dart';
import 'package:splitt/common/elevated_widget.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/expense/presentation/bloc/expenses_bloc.dart';
import 'package:splitt/features/expense/presentation/bloc/save_expense_bloc.dart';
import 'package:splitt/features/expense/presentation/views/expense_details.dart';
import 'package:splitt/features/group/domain/group_users_data_store.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/group/presentation/views/add_group_members_screen.dart';
import 'package:splitt/features/settle_up/presentation/views/settle_up_screen.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/common/utils/date_time_extensions.dart';
import 'package:splitt/common/utils/string_extensions.dart';
import 'package:splitt/features/group/presentation/models/group_expense.dart';
import 'package:splitt/features/expense/presentation/views/expense_provider.dart';
import 'package:splitt/features/expense/presentation/views/add_edit_expense_screen.dart';
import 'package:splitt/theme/theme_extension.dart';

class GroupDetails extends StatefulWidget {
  final Group group;

  const GroupDetails({
    super.key,
    required this.group,
  });

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  late final GroupExpense groupExpense;

  late final List<User> users;
  late final ExpensesBloc expensesBloc;
  bool _isModified = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    groupExpense = GroupExpense(
      savedExpenses: [],
      groupId: widget.group.id,
    );
    users = widget.group.users;
    GroupUsersDataStore().groupId = widget.group.id;
    GroupUsersDataStore().users = widget.group.users;
    expensesBloc = ExpensesBloc();
    expensesBloc.getGroupExpenses(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _isModified);
        return false;
      },
      child: BlocProvider(
        create: (_) => expensesBloc,
        child: Scaffold(
          floatingActionButton: AddExpenseButton(
            onTap: () {
              final newExpense = Expense(
                groupId: widget.group.id,
                users: users,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseProvider(
                    expense: newExpense,
                    child: AddEditExpenseScreen(
                      expenseBloc: SaveExpenseBloc(),
                      onSave: () {
                        setState(() {
                          groupExpense.savedExpenses.add(newExpense);
                          _isModified = true;
                        });
                        expensesBloc.getGroupExpenses(widget.group.id);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 100.0,
                  floating: false,
                  pinned: true,
                  stretch: true,
                  leading: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final double maxHeight = constraints.biggest.height;
                      const double minHeight = kToolbarHeight;

                      final double t =
                          (maxHeight - minHeight - 24) / (100 - kToolbarHeight);
                      final double targetOpacity = 1 - t.clamp(0.0, 1.0);

                      return Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: [
                          Avatar(
                            seed: widget.group.name,
                            borderRadius: BorderRadius.zero,
                            size: double.infinity,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: targetOpacity,
                                  end: targetOpacity,
                                ),
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeInOutCubic,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  widget.group.name,
                                  style: context.f.heading1.copyWith(
                                    color: context.c.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -30,
                            left: 32,
                            child: Opacity(
                              opacity: t.clamp(0.0, 1.0),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Avatar(
                                    seed: widget.group.name,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ];
            },
            body: SafeArea(
              child: CustomRefreshIndicator(
                controller: scrollController,
                onRefresh: () {
                  return expensesBloc.getGroupExpenses(widget.group.id);
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.group.name,
                              style: context.f.heading2,
                            ),
                            if (groupExpense.getFinalRemainingAmount() != 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      groupExpense.getFinalRemainingAmount() > 0
                                          ? "You are owed "
                                          : "You owe ",
                                      style: context.f.body2.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: groupExpense
                                                    .getFinalRemainingAmount() >
                                                0
                                            ? context.c.primaryColor
                                            : context.c.secondaryColor,
                                      ),
                                    ),
                                    CurrencyAmount(
                                      amount: groupExpense
                                          .getFormattedFinalRemainingAmount(),
                                      style: context.f.body2.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: groupExpense
                                                    .getFinalRemainingAmount() >
                                                0
                                            ? context.c.primaryColor
                                            : context.c.secondaryColor,
                                      ),
                                    ),
                                    Text(
                                      " overall",
                                      style: context.f.body2.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: groupExpense
                                                    .getFinalRemainingAmount() >
                                                0
                                            ? context.c.primaryColor
                                            : context.c.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (groupExpense.savedExpenses.isEmpty)
                              Text(
                                "No expenses here yet",
                                style: context.f.body3.copyWith(
                                  color: context.c.secondaryTextColor,
                                ),
                              )
                            else if (groupExpense.getRemainingAmounts().isEmpty)
                              Text(
                                "You are all settled up in this group",
                                style: context.f.body3.copyWith(
                                  color: context.c.secondaryTextColor,
                                ),
                              ),
                            ...groupExpense
                                .getRemainingAmounts()
                                .map((id, amount) {
                              return MapEntry(
                                id,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      amount > 0
                                          ? "${users.firstWhere((user) => user.id == id).name.capitalize()} owes you "
                                          : "You owe ${users.firstWhere((user) => user.id == id).name} ",
                                      style: context.f.body3,
                                    ),
                                    CurrencyAmount(
                                      amount: amount.abs().toStringAsFixed(2),
                                      style: context.f.body3,
                                    ),
                                  ],
                                ),
                              );
                            }).values,
                          ],
                        ),
                      ),
                      if (groupExpense.getFinalRemainingAmount() != 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: SizedBox(
                            width: 88,
                            child: ElevatedWidget(
                              verticalPadding: 4,
                              backgroundColor: context.c.secondaryColor,
                              onTap: () async {
                                final res = await Navigator.push(
                                  context,
                                  slideFromBottom(
                                    SettleUpScreen(
                                      groupExpense: groupExpense,
                                    ),
                                  ),
                                );
                                if (res != null) {
                                  expensesBloc
                                      .getGroupExpenses(widget.group.id);
                                }
                              },
                              child: Text(
                                "Settle up",
                                style: context.f.body2.copyWith(
                                  color: context.c.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      //TODO : check this
                      if (true || widget.group.shouldShowAddMembersButton())
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                slideFromBottom(
                                  AddGroupMembersScreen(
                                    group: widget.group,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.c.primaryColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_outlined,
                                      color: context.c.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Add members",
                                      style: context.f.body2.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: context.c.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      BlocConsumer(
                        bloc: expensesBloc,
                        listener: (_, state) {
                          if (state is Success) {
                            setState(() {
                              groupExpense.savedExpenses = state.data.toList();
                            });
                          }
                        },
                        builder: (context, UIState state) {
                          if (state is Success) {
                            return _ExpenseList(
                                savedExpenses: state.data,
                                onModified: () {
                                  setState(() {
                                    _isModified = true;
                                  });
                                });
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseList extends StatelessWidget {
  final List<Expense> savedExpenses;
  final VoidCallback? onModified;

  const _ExpenseList({
    super.key,
    required this.savedExpenses,
    this.onModified,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        itemCount: savedExpenses.length,
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (index == 0 ||
                  !(savedExpenses[index - 1]
                      .createdAt
                      .isSameMonth(savedExpenses[index].createdAt)))
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    DateFormat("MMMM yyyy")
                        .format(savedExpenses[index].createdAt),
                    style: context.f.body3.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              _ExpenseItem(
                expense: savedExpenses[index],
                onModified: onModified,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onModified;

  const _ExpenseItem({
    super.key,
    required this.expense,
    this.onModified,
  });

  @override
  Widget build(BuildContext context) {
    final remainingAmount = expense.getRemainingAmount();
    return InkWell(
      onTap: () async {
        final expensesBloc = context.read<ExpensesBloc>();
        final res = await Navigator.push(
          context,
          slideFromRight(
            ExpenseDetails(expense: expense),
          ),
        );
        if (res == true) {
          onModified?.call();
          expensesBloc.getGroupExpenses(expense.groupId);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  Text(
                    DateFormat("MMM").format(expense.createdAt),
                    style: context.f.body3.copyWith(
                      color: context.c.secondaryTextColor,
                    ),
                  ),
                  Text(
                    DateFormat("dd").format(expense.createdAt),
                    style: context.f.body2.copyWith(
                      color: context.c.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (expense.isSettleUp)
              SizedBox(
                height: 36,
                width: 36,
                child: Image.asset("assets/images/settle.png"),
              )
            else
              Container(
                height: 36,
                width: 36,
                color: context.c.hintColor,
                child: Image.asset("assets/images/expense.png"),
              ),
            const SizedBox(width: 12),
            if (expense.isSettleUp)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${expense.getPaidBy().capitalize()} paid ${expense.getSettledToUser()} ",
                    style: context.f.body2.copyWith(
                      fontSize: 10,
                    ),
                  ),
                  CurrencyAmount(
                    amount: expense.getPaidAmount(),
                    style: context.f.body2.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    style: context.f.body1,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        remainingAmount != 0
                            ? "${expense.getPaidBy().capitalize()} paid "
                            : expense.isPaidForMySelf()
                                ? "You paid for yourself"
                                : "You were not involved",
                        style: context.f.body2.copyWith(
                          fontSize: 10,
                          color: context.c.secondaryTextColor,
                        ),
                      ),
                      if (remainingAmount != 0)
                        CurrencyAmount(
                          amount: expense.getPaidAmount(),
                          style: context.f.body2.copyWith(
                            fontSize: 10,
                            color: context.c.secondaryTextColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            const Spacer(),
            if (!expense.isSettleUp)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    remainingAmount > 0
                        ? "you lent"
                        : remainingAmount < 0
                            ? "you borrowed"
                            : expense.isPaidForMySelf()
                                ? "no balance"
                                : "not involved",
                    style: context.f.body2.copyWith(
                      color: remainingAmount > 0
                          ? context.c.primaryColor
                          : remainingAmount < 0
                              ? context.c.secondaryColor
                              : context.c.secondaryTextColor,
                      fontSize: 10,
                    ),
                  ),
                  if (remainingAmount != 0)
                    CurrencyAmount(
                      amount: expense.getFormattedRemainingAmount(),
                      style: context.f.body2.copyWith(
                        color: remainingAmount > 0
                            ? context.c.primaryColor
                            : context.c.secondaryColor,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
