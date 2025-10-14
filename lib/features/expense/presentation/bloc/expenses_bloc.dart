import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/expense/domain/repository/expense_repository.dart';
import 'package:splitt/features/expense/domain/repository/expense_repository_impl.dart';
import 'package:splitt/features/core/models/ui_state.dart';

class ExpensesBloc extends Cubit<UIState<List<Expense>>> {
  final ExpenseRepository _expenseRepository;

  ExpensesBloc({
    ExpenseRepository? expenseRepository,
  })  : _expenseRepository = expenseRepository ?? ExpenseRepositoryImpl(),
        super(const Idle());

  Future getGroupExpenses(String groupId) async {
    emit(const Loading());
    try {
      final expenses = await _expenseRepository.getGroupExpenses(groupId);
      final expenseList =
          expenses.map((expense) => Expense.fromExpenseModel(expense)).toList();
      emit(Success(expenseList));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
