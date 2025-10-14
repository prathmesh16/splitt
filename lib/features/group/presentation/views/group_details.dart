import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/expense/presentation/bloc/expenses_bloc.dart';
import 'package:splitt/features/group/domain/group_users_data_store.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/common/utils/date_time_extensions.dart';
import 'package:splitt/common/utils/string_extensions.dart';
import 'package:splitt/features/group/presentation/models/group_expense.dart';
import 'package:splitt/features/split/views/expense_provider.dart';
import 'package:splitt/features/split/views/new_split.dart';

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

  final GroupExpense groupExpense = GroupExpense(
    savedExpenses: [],
  );

  late final List<User> users;
  late final ExpensesBloc expensesBloc;

  @override
  void initState() {
    super.initState();
    users = widget.group.users;
    GroupUsersDataStore().groupId = widget.group.id;
    GroupUsersDataStore().users = widget.group.users;
    expensesBloc = ExpensesBloc();
    expensesBloc.getGroupExpenses(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newExpense = Expense(
            groupId: widget.group.id,
            users: users,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExpenseProvider(
                expense: newExpense,
                child: NewSplit(
                  onSave: () {
                    setState(() {
                      groupExpense.savedExpenses.add(newExpense);
                    });
                    expensesBloc.getGroupExpenses(widget.group.id);
                  },
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.sticky_note_2_outlined),
      ),
      body: SafeArea(
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
                  ...groupExpense.getRemainingAmounts().map((id, amount) {
                    return MapEntry(
                      id,
                      Text(
                        amount > 0
                            ? "${users.firstWhere((user) => user.id == id).name.capitalize()} owes you ₹${amount.toStringAsFixed(2)}"
                            : "You owe ${users.firstWhere((user) => user.id == id).name} ₹${amount.abs().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).values,
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer(
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
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseList extends StatelessWidget {
  final List<Expense> savedExpenses;

  const _ExpenseList({
    super.key,
    required this.savedExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        itemCount: savedExpenses.length,
        itemBuilder: (_, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (index == 0 ||
                  !(savedExpenses[index - 1]
                      .date
                      .isSameMonth(savedExpenses[index].date)))
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    DateFormat("MMMM yyyy").format(savedExpenses[index].date),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              _ExpenseItem(
                expense: savedExpenses[index],
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

  const _ExpenseItem({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final remainingAmount = expense.getRemainingAmount();
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Text(
                  DateFormat("MMM").format(expense.date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat("dd").format(expense.date),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 36,
            width: 36,
            color: Colors.blueGrey[100],
            child: const Icon(Icons.event_note_outlined),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expense.name),
              Text(
                remainingAmount != 0
                    ? "${expense.getPaidBy().capitalize()} paid ₹${expense.getPaidAmount()}"
                    : "You were not involved",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                remainingAmount > 0
                    ? "you lent"
                    : remainingAmount < 0
                        ? "you borrowed"
                        : "not involved",
                style: TextStyle(
                  color: remainingAmount > 0
                      ? Constants.lentColor
                      : remainingAmount < 0
                          ? Constants.borrowedColor
                          : Colors.grey,
                  fontSize: 10,
                ),
              ),
              if (remainingAmount != 0)
                Text(
                  "₹${expense.getFormattedRemainingAmount()}",
                  style: TextStyle(
                    color: remainingAmount > 0
                        ? Constants.lentColor
                        : Constants.borrowedColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
