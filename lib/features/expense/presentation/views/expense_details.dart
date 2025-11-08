import 'package:flutter/material.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/currency_amount.dart';
import 'package:splitt/common/elevated_widget.dart';
import 'package:splitt/common/hierarchy_widget.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/common/utils/string_extensions.dart';
import 'package:splitt/features/expense/presentation/bloc/edit_expense_bloc.dart';
import 'package:splitt/features/expense/presentation/views/add_edit_expense_screen.dart';
import 'package:splitt/features/expense/presentation/views/delete_button.dart';
import 'package:splitt/features/settle_up/presentation/views/record_payment_screen.dart';
import 'package:splitt/features/expense/presentation/views/expense_provider.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';
import 'package:splitt/theme/theme_extension.dart';

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
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Text(
                        "Details",
                        style: context.f.body1,
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
                                          expense.updatedBy =
                                              UserDataStore().me!;
                                          expense.updatedAt = DateTime.now();
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
                            style: context.f.heading2,
                          ),
                          CurrencyAmount(
                            amount: widget.expense.getFormattedAmount(),
                            style: context.f.heading1.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "Added by ${widget.expense.getExpenseAddedBy()} on ${widget.expense.getFormattedCreatedAt()}",
                            style: context.f.body2.copyWith(
                              color: context.c.secondaryTextColor,
                            ),
                          ),
                          if (widget.expense.isExpenseUpdated)
                            Text(
                              "Last updated by ${widget.expense.getExpenseUpdatedBy()} on ${widget.expense.getFormattedUpdatedAt()}",
                              style: context.f.body2.copyWith(
                                color: context.c.secondaryTextColor,
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
                child: HierarchyWidget(
                  childLeftPadding: 23.5,
                  header: _PaidDetailsRow(
                    name: widget.expense.getPaidBy(),
                    amount: widget.expense.getFormattedAmount(),
                    isPaidBy: true,
                  ),
                  children: widget.expense
                      .getIncludedIdNames()
                      .map(
                        (pair) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: _PaidDetailsRow(
                            name: pair.second,
                            amount: widget.expense
                                .getFormattedBorrowedAmount(id: pair.first),
                          ),
                        ),
                      )
                      .toList(),
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
  final String name;
  final String amount;
  final bool isPaidBy;

  const _PaidDetailsRow({
    required this.name,
    required this.amount,
    this.isPaidBy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(
          height: isPaidBy ? 48 : 24,
          width: isPaidBy ? 48 : 24,
        ),
        SizedBox(
          width: isPaidBy ? 16 : 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${name.capitalize()} ${isPaidBy ? "paid" : "owe"} ",
              style: isPaidBy
                  ? context.f.body1
                  : context.f.body3.copyWith(
                      color: context.c.secondaryTextColor,
                    ),
            ),
            CurrencyAmount(
              amount: amount,
              style: isPaidBy
                  ? context.f.body1
                  : context.f.body3.copyWith(
                      color: context.c.secondaryTextColor,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
