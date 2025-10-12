import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/models/expense.dart';

class ExpenseProvider extends StatelessWidget {
  final Expense expense;
  final Widget child;

  const ExpenseProvider({
    super.key,
    required this.expense,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: expense,
      child: child,
    );
  }
}
