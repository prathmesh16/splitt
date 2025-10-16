import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/expense_model.dart';

abstract class ExpenseAPIService {
  Future<APIResponse> saveExpense(ExpenseModel expense);

  Future<APIResponse> getGroupExpenses(String groupId);

  Future<APIResponse> deleteExpense(String expenseId);
}
