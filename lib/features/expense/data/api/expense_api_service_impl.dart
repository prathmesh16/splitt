import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/core/network/base_api_service.dart';
import 'package:splitt/features/expense/data/api/expense_api_service.dart';
import 'package:splitt/features/expense/data/models/expense_model.dart';

class ExpenseApiServiceImpl extends BaseAPIService
    implements ExpenseAPIService {
  @override
  Future<APIResponse> saveExpense(ExpenseModel expense) {
    return post('expenses/group', body: expense.toJson());
  }

  @override
  Future<APIResponse> editExpense(ExpenseModel expense) {
    return put('expenses/${expense.id}', body: expense.toJson());
  }

  @override
  Future<APIResponse> getGroupExpenses(String groupId) {
    return get('expenses/group/$groupId');
  }

  @override
  Future<APIResponse> deleteExpense(String expenseId) {
    return delete("expenses/$expenseId");
  }
}
