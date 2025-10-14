import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/expense/data/api/expense_api_service.dart';
import 'package:splitt/features/expense/data/api/expense_api_service_impl.dart';
import 'package:splitt/features/expense/domain/repository/expense_repository.dart';
import 'package:splitt/features/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseAPIService _expenseAPIService;

  ExpenseRepositoryImpl({
    ExpenseAPIService? expenseAPIService,
  }) : _expenseAPIService = expenseAPIService ?? ExpenseApiServiceImpl();

  @override
  Future saveExpense(Expense expense) {
    return _expenseAPIService.saveExpense(ExpenseModel.fromExpense(expense));
  }
}
