import 'package:flutter/material.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/elevated_widget.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:splitt/features/expense/presentation/views/save_button.dart';
import 'package:splitt/features/group/domain/group_users_data_store.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class RecordPaymentScreen extends StatefulWidget {
  final User user;
  final double amount;
  final String groupId;
  final Expense? expense;
  final VoidCallback? onSave;
  final ExpenseBloc expenseBloc;

  const RecordPaymentScreen({
    super.key,
    required this.user,
    required this.amount,
    required this.groupId,
    required this.expenseBloc,
    this.expense,
    this.onSave,
  });

  @override
  State<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends State<RecordPaymentScreen> {
  late final TextEditingController amountController;
  late final FocusNode amountFocusNode;
  late final Expense expense;

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: widget.amount.abs().toStringAsFixed(2));
    amountFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      amountFocusNode.requestFocus();
    });
    expense = widget.expense ??
        Expense(
          users: GroupUsersDataStore().users,
          groupId: widget.groupId,
          amount: widget.amount.abs(),
          isSettleUp: true,
        )
      ..name = "Settle up"
      ..selectedUsers.clear()
      ..selectedUsers
          .addAll([widget.amount < 0 ? widget.user.id : UserDataStore().me.id])
      ..setPaidBy(widget.amount > 0 ? widget.user.id : UserDataStore().me.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                  const Text(
                    "Record a payment",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SaveButton(
                    expenseBloc: widget.expenseBloc,
                    onTap: () {
                      final amount = double.tryParse(amountController.text);
                      if (amount != null) {
                        widget.expenseBloc.saveExpense(expense);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(milliseconds: 500),
                            content: Text("Please enter amount"),
                          ),
                        );
                      }
                    },
                    onSuccess: () {
                      Navigator.pop(context, true);
                      widget.onSave?.call();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Avatar(
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_right_alt_rounded,
                        size: 48,
                      ),
                      SizedBox(width: 8),
                      Avatar(
                        height: 60,
                        width: 60,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    widget.amount > 0
                        ? "${widget.user.name} paid you"
                        : "You paid ${widget.user.name}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ElevatedWidget(
                        child: Icon(
                          Icons.currency_rupee,
                          color: Colors.black,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: TextField(
                            focusNode: amountFocusNode,
                            controller: amountController,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: "0.00",
                              hintStyle: TextStyle(
                                fontSize: 28,
                                color: Colors.grey[400],
                              ),
                              isDense: true,
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Constants.primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            cursorColor: Constants.primaryColor,
                            cursorHeight: 36,
                            onChanged: (String? value) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              expense.amount =
                                  double.tryParse(value ?? "") ?? 0;
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ),
                    ],
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
