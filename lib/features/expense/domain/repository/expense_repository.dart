import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/expense_model.dart';

abstract class ExpenseRepository {
  Future saveExpense(Expense expense);

  Future<List<ExpenseModel>> getGroupExpenses(String groupId);

  Future deleteExpense(String expenseId);
}
