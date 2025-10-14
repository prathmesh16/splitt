import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/expense/domain/repository/expense_repository.dart';
import 'package:splitt/features/expense/domain/repository/expense_repository_impl.dart';

class SaveExpenseBloc extends Cubit {
  final ExpenseRepository _expenseRepository;

  SaveExpenseBloc({
    ExpenseRepository? expenseRepository,
  })  : _expenseRepository = expenseRepository ?? ExpenseRepositoryImpl(),
        super(const Idle());

  Future saveExpense(Expense expense) async {
    emit(const Loading());
    try {
      await _expenseRepository.saveExpense(expense);
      emit(const Success(true));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
