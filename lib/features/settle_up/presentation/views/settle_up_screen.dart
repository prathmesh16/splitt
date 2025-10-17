import 'package:flutter/material.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/page_transitions.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/expense/presentation/bloc/save_expense_bloc.dart';
import 'package:splitt/features/group/domain/group_users_data_store.dart';
import 'package:splitt/features/group/presentation/models/group_expense.dart';
import 'package:splitt/features/settle_up/presentation/views/record_payment_screen.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class SettleUpScreen extends StatelessWidget {
  final GroupExpense groupExpense;

  const SettleUpScreen({
    super.key,
    required this.groupExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      size: 28,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 48),
                        child: Text(
                          "Settle up",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Text(
                "Which balance do you want to settle?",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
            ...groupExpense
                .getRemainingAmounts()
                .map(
                  (id, amount) => MapEntry(
                    id,
                    Column(
                      children: [
                        _UserTile(
                          user: GroupUsersDataStore().getUser(id)!,
                          amount: amount,
                          groupId: groupExpense.groupId,
                        ),
                        const CustomDivider(),
                      ],
                    ),
                  ),
                )
                .values
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  final double amount;
  final String groupId;

  const _UserTile({
    super.key,
    required this.user,
    required this.amount,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final res = await Navigator.push(
          context,
          slideFromRight(
            RecordPaymentScreen(
              user: user,
              amount: amount,
              groupId: groupId,
              expenseBloc: SaveExpenseBloc(),
            ),
          ),
        );
        if (res != null) {
          if (context.mounted) {
            Navigator.pop(context, true);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 10,
          bottom: 10,
        ),
        child: Row(
          children: [
            const Avatar(
              height: 48,
              width: 48,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  amount < 0 ? "you owe" : "owes you",
                  style: TextStyle(
                    color: amount > 0
                        ? Constants.lentColor
                        : Constants.borrowedColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "₹${amount.abs().toStringAsFixed(2)}",
                  style: TextStyle(
                    color: amount > 0
                        ? Constants.lentColor
                        : Constants.borrowedColor,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
