import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/elevated_widget.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/features/expense/presentation/bloc/expense_bloc.dart';
import 'package:splitt/features/expense/presentation/views/save_button.dart';
import 'package:splitt/features/expense/presentation/views/expense_provider.dart';
import 'package:splitt/features/expense/presentation/views/paid_by_screen.dart';
import 'package:splitt/features/split/views/split_screen.dart';
import 'package:splitt/theme/theme_extension.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final VoidCallback onSave;
  final ExpenseBloc expenseBloc;

  const AddEditExpenseScreen({
    super.key,
    required this.onSave,
    required this.expenseBloc,
  });

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  late final TextEditingController nameController;
  late final FocusNode nameFocusNode;
  late final FocusNode amountFocusNode;
  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    final expense = context.read<Expense>();
    nameController = TextEditingController(text: expense.name);
    nameFocusNode = FocusNode();
    amountFocusNode = FocusNode();
    amountController = TextEditingController(
      text: expense.amount != 0 ? expense.amount.toString() : null,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (expense.name.isNotEmpty) {
        amountFocusNode.requestFocus();
      } else {
        nameFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close),
                  ),
                  Text(
                    widget.expenseBloc.screenName,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SaveButton(
                    expenseBloc: widget.expenseBloc,
                    onTap: () {
                      final description = nameController.text;
                      final amount = double.tryParse(amountController.text);
                      if (description.isNotEmpty && amount != null) {
                        widget.expenseBloc.saveExpense(context.read<Expense>());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(milliseconds: 500),
                            content: Text("Please enter all details"),
                          ),
                        );
                      }
                    },
                    onSuccess: () {
                      widget.onSave.call();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<Expense>(builder: (_, expense, __) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const ElevatedWidget(
                            child: Icon(
                              Icons.event_note_sharp,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextField(
                                focusNode: nameFocusNode,
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: "Enter a description",
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.normal,
                                  ),
                                  contentPadding: const EdgeInsets.only(top: 8),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.c.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                cursorColor: context.c.primaryColor,
                                onChanged: (String? value) {
                                  expense.name = value ?? "";
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const ElevatedWidget(
                            child: Icon(
                              Icons.currency_rupee,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TextField(
                                focusNode: amountFocusNode,
                                controller: amountController,
                                decoration: InputDecoration(
                                  hintText: "0.00",
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[400],
                                  ),
                                  contentPadding: const EdgeInsets.only(top: 8),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.c.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                cursorColor: context.c.primaryColor,
                                onChanged: (String? value) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  expense.amount =
                                      double.tryParse(value ?? "") ?? 0;
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Paid by"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ElevatedWidget(
                              verticalPadding: 4,
                              onTap: () {
                                final amount = amountController.text;
                                if ((num.tryParse(amount) ?? 0) > 0) {
                                  Navigator.push(
                                    context,
                                    slideFromBottom(
                                      ExpenseProvider(
                                        expense: expense,
                                        child: const PaidByScreen(),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(milliseconds: 500),
                                      content: Text("Please enter amount"),
                                    ),
                                  );
                                }
                              },
                              child: Text(expense.getPaidBy()),
                            ),
                          ),
                          const Text("and split"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ElevatedWidget(
                              verticalPadding: 4,
                              onTap: () {
                                final amount = amountController.text;
                                if ((num.tryParse(amount) ?? 0) > 0) {
                                  final expenseCopy = expense.copy();
                                  Navigator.push(
                                    context,
                                    slideFromBottom(
                                      ExpenseProvider(
                                        expense: expenseCopy,
                                        child: SplitScreen(
                                          onDone: () {
                                            setState(() {
                                              expense
                                                  .updateExpense(expenseCopy);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(milliseconds: 500),
                                      content: Text("Please enter amount"),
                                    ),
                                  );
                                }
                              },
                              child: Text(expense.splitType.splitTypeName),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
