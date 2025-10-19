import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class GroupExpense {
  List<Expense> savedExpenses;
  final String groupId;

  GroupExpense({
    required this.savedExpenses,
    required this.groupId,
  });

  final User me = UserDataStore().me!;

  Map<String, double> getRemainingAmounts() {
    final Map<String, double> amounts = {};
    for (final expense in savedExpenses) {
      if (expense.getPaidByID() == me.id) {
        final includedIds = expense.getIncludedIds();
        for (final id in includedIds) {
          if (id == me.id) {
            continue;
          }
          final remainingAmount = expense.getRemainingAmount(id: id);
          amounts[id] = (amounts[id] ?? 0) - remainingAmount;
        }
      } else {
        final remainingAmount = expense.getRemainingAmount();
        amounts[expense.getPaidByID()] =
            (amounts[expense.getPaidByID()] ?? 0) + remainingAmount;
      }
    }
    return amounts..removeWhere((_, amount) => amount == 0);
  }

  double getFinalRemainingAmount() {
    final amounts = getRemainingAmounts();
    if (amounts.isEmpty) {
      return 0;
    }
    return amounts.values.reduce((a, b) => a + b);
  }

  String getFormattedFinalRemainingAmount() {
    return getFinalRemainingAmount().abs().toStringAsFixed(2);
  }
}
