import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/core/models/api_response.dart';

abstract class ExpenseRepository {
  Future saveExpense(Expense expense);
}
