import 'package:flutter/material.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/elevated_widget.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/common/utils/string_extensions.dart';
import 'package:splitt/features/expense/presentation/bloc/edit_expense_bloc.dart';
import 'package:splitt/features/expense/presentation/views/add_edit_expense_screen.dart';
import 'package:splitt/features/expense/presentation/views/delete_button.dart';
import 'package:splitt/features/group/domain/group_users_data_store.dart';
import 'package:splitt/features/settle_up/presentation/views/record_payment_screen.dart';
import 'package:splitt/features/split/views/expense_provider.dart';

class ExpenseDetails extends StatefulWidget {
  final Expense expense;

  const ExpenseDetails({
    super.key,
    required this.expense,
  });

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  bool isExpenseEdited = false;

  @override
  Widget build(BuildContext context) {
    final includedIds = widget.expense.getIncludedIds();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isExpenseEdited);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context, isExpenseEdited),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 48),
                      child: Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        DeleteButton(
                          onTap: (deleteExpenseBloc) {
                            deleteExpenseBloc
                                .deleteExpense(widget.expense.id ?? "");
                          },
                          onSuccess: () {
                            setState(() {
                              isExpenseEdited = true;
                            });
                            Navigator.pop(context, true);
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              slideFromBottom(
                                () {
                                  final expense = widget.expense.copy();
                                  if (expense.isSettleUp) {
                                    return RecordPaymentScreen(
                                      expense: expense,
                                      amount: expense.amount,
                                      user: expense.getSettlementUser()!,
                                      groupId: expense.groupId,
                                      expenseBloc: EditExpenseBloc(),
                                      onSave: () {
                                        setState(() {
                                          isExpenseEdited = true;
                                          widget.expense.updateExpense(expense);
                                        });
                                      },
                                    );
                                  }
                                  return ExpenseProvider(
                                    expense: expense,
                                    child: AddEditExpenseScreen(
                                      expenseBloc: EditExpenseBloc(),
                                      onSave: () {
                                        setState(() {
                                          isExpenseEdited = true;
                                          widget.expense.updateExpense(expense);
                                        });
                                      },
                                    ),
                                  );
                                }(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.mode_edit_outlined),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ElevatedWidget(
                      child: Icon(
                        Icons.event_note_sharp,
                        color: Colors.black,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.expense.name,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            "₹${widget.expense.getFormattedAmount()}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Added by ${widget.expense.createdBy.name} on ${widget.expense.getFormattedDate()}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _PaidDetailsRow(
                      name: widget.expense.getPaidBy(),
                      amount: widget.expense.getFormattedAmount(),
                      isPaidBy: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                      ),
                      child: Column(
                        children: [
                          ...includedIds
                              .asMap()
                              .map((index, id) => MapEntry(
                                  index,
                                  _PaidDetailsRow(
                                    isLast: index == includedIds.length - 1,
                                    name: GroupUsersDataStore()
                                            .getUser(id)
                                            ?.name ??
                                        "",
                                    amount: widget.expense
                                        .getFormattedBorrowedAmount(id: id),
                                  )))
                              .values,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaidDetailsRow extends StatelessWidget {
  final bool isLast;
  final String name;
  final String amount;
  final bool isPaidBy;

  const _PaidDetailsRow({
    super.key,
    this.isLast = false,
    required this.name,
    required this.amount,
    this.isPaidBy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isPaidBy)
          Container(
            width: 0.5,
            height: isLast ? 16 : 32,
            margin: EdgeInsets.only(bottom: isLast ? 16 : 0),
            color: Constants.hierarchyColor,
          ),
        if (!isPaidBy)
          Container(
            width: 24,
            height: 0.5,
            color: Constants.hierarchyColor,
          ),
        if (!isPaidBy) const SizedBox(width: 8),
        Avatar(
          height: isPaidBy ? 48 : 24,
          width: isPaidBy ? 48 : 24,
        ),
        SizedBox(
          width: isPaidBy ? 16 : 8,
        ),
        Text(
          "${name.capitalize()} ${isPaidBy ? "paid" : "owe"} ₹$amount",
          style: isPaidBy
              ? const TextStyle(
                  fontSize: 16,
                )
              : const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
        ),
      ],
    );
  }
}
