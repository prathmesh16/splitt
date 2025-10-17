import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/expense/presentation/bloc/expense_bloc.dart';

class EditExpenseBloc extends ExpenseBloc {
  @override
  String get screenName => "Edit expense";

  @override
  Future saveExpenseToAPI(Expense expense) {
    return expenseRepository.editExpense(expense);
  }
}
