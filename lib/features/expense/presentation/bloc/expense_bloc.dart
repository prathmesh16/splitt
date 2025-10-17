import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/expense/domain/repository/expense_repository.dart';
import 'package:splitt/features/expense/domain/repository/expense_repository_impl.dart';

abstract class ExpenseBloc extends Cubit<UIState> {
  final ExpenseRepository _expenseRepository;

  ExpenseBloc({
    ExpenseRepository? expenseRepository,
  })  : _expenseRepository = expenseRepository ?? ExpenseRepositoryImpl(),
        super(const Idle());

  ExpenseRepository get expenseRepository => _expenseRepository;

  String get screenName;

  Future saveExpense(Expense expense) async {
    emit(const Loading());
    try {
      await saveExpenseToAPI(expense);
      emit(const Success(true));
    } catch (e, s) {
      print(e);
      print(s);
      emit(Failure(e as Error));
    }
  }

  Future saveExpenseToAPI(Expense expense);
}
