import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/elevated_widget.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/split/views/expense_provider.dart';
import 'package:splitt/features/split/views/paid_by.dart';
import 'package:splitt/features/split/views/split_screen.dart';

class NewSplit extends StatefulWidget {
  final VoidCallback onSave;

  const NewSplit({
    super.key,
    required this.onSave,
  });

  @override
  State<NewSplit> createState() => _NewSplitState();
}

class _NewSplitState extends State<NewSplit> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
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
                  const Text(
                    "Add an expense",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final description = descriptionController.text;
                      final amount = double.tryParse(amountController.text);
                      if (description.isNotEmpty && amount != null) {
                        widget.onSave.call();
                        Navigator.pop(context);
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
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
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
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  hintText: "Enter a description",
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.normal,
                                  ),
                                  contentPadding: const EdgeInsets.only(top: 8),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Constants.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                cursorColor: Constants.primaryColor,
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
                                controller: amountController,
                                decoration: InputDecoration(
                                  hintText: "0.00",
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[400],
                                  ),
                                  contentPadding: const EdgeInsets.only(top: 8),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Constants.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                cursorColor: Constants.primaryColor,
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
                                        child: const PaidBy(),
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
                                  Navigator.push(
                                    context,
                                    slideFromBottom(
                                      ExpenseProvider(
                                        expense: expense,
                                        child: const SplitScreen(),
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
