import 'package:flutter/material.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/elevated_widget.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/utils/string_extensions.dart';
import 'package:splitt/features/expense/presentation/views/delete_button.dart';
import 'package:splitt/features/group/domain/group_users_data_store.dart';

class ExpenseDetails extends StatelessWidget {
  final Expense expense;

  const ExpenseDetails({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
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
                          deleteExpenseBloc.deleteExpense(expense.id ?? "");
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
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
                  SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "₹${expense.getFormattedAmount()}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Added by ${expense.createdBy.name} on ${expense.getFormattedDate()}",
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
                    name: expense.getPaidBy(),
                    amount: expense.getFormattedAmount(),
                    isPaidBy: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 52,
                      top: 8,
                    ),
                    child: Column(
                      children: [
                        ...expense.getIncludedIds().map(
                              (id) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: _PaidDetailsRow(
                                  name:
                                      GroupUsersDataStore().getUser(id)?.name ??
                                          "",
                                  amount: expense.getFormattedBorrowedAmount(
                                      id: id),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    super.key,
    required this.name,
    required this.amount,
    this.isPaidBy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(
          height: isPaidBy ? 36 : 24,
          width: isPaidBy ? 36 : 24,
        ),
        SizedBox(
          width: isPaidBy ? 16 : 8,
        ),
        Text(
          "${name.capitalize()} ${isPaidBy ? "paid" : "owe"} ₹$amount",
          style: isPaidBy
              ? null
              : const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
        ),
      ],
    );
  }
}
