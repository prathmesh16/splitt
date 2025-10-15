import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/features/split/models/spilt_type.dart';

class GroupExpense {
  List<Expense> savedExpenses;

  GroupExpense({
    required this.savedExpenses,
  });

  final User me = const User(
    id: "u100",
    name: "Alice",
  );

  List<String> getIncludedIds(Expense expense) {
    final List<String> ids = [];
    switch (expense.splitType) {
      case SplitType.equal:
        ids.addAll(expense.selectedUsers);
      case SplitType.amount:
        expense.amounts.forEach((id, amount) {
          if (amount != 0) {
            ids.add(id);
          }
        });
      case SplitType.percentage:
        expense.percentages.forEach((id, amount) {
          if (amount != 0) {
            ids.add(id);
          }
        });
      case SplitType.share:
        expense.shares.forEach((id, amount) {
          if (amount != 0) {
            ids.add(id);
          }
        });
      case SplitType.adjustment:
        for (final user in expense.users) {
          if (expense.getUserAdjustmentTotalAmount(user.id) != 0) {
            ids.add(user.id);
          }
        }
    }
    return ids;
  }

  Map<String, double> getRemainingAmounts() {
    final Map<String, double> amounts = {};
    for (final expense in savedExpenses) {
      if (expense.getPaidByID() == me.id) {
        final includedIds = getIncludedIds(expense);
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
}
