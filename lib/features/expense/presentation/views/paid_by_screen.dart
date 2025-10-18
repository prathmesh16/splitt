import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/common/utils/constants.dart';

class PaidByScreen extends StatelessWidget {
  const PaidByScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 48),
                        child: Text(
                          "Choose payer",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomDivider(
              color: Colors.grey[200],
            ),
            Expanded(
              child: Consumer<Expense>(
                builder: (context, expense, _) {
                  return _UserList(
                    users: expense.users,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final List<User> users;

  const _UserList({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length,
      itemBuilder: (_, index) {
        return _UserTile(
          user: users[index],
        );
      },
      separatorBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomDivider(
            color: Colors.grey[200],
          ),
        );
      },
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;

  const _UserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Expense>(builder: (context, expense, _) {
      return InkWell(
        onTap: () {
          expense.setPaidBy(user.id);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.network(
                  "https://avatar.iran.liara.run/public/boy",
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      expense.isUserPaid(user.id) ? FontWeight.w500 : null,
                ),
              ),
              const Spacer(),
              if (expense.paidByLength == 1 && expense.isUserPaid(user.id))
                const Icon(
                  Icons.check_rounded,
                  size: 12,
                  color: Constants.primaryColor,
                ),
            ],
          ),
        ),
      );
    });
  }
}
