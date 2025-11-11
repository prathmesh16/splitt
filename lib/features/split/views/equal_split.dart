import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/avatar.dart';
import 'package:splitt/common/currency_amount.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/theme/theme_extension.dart';

class EqualSplit extends StatelessWidget {
  final List<User> users;

  const EqualSplit({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Expense>(
      builder: (_, expense, __) {
        return Column(
          children: [
            Expanded(
              child: _UserList(
                users: users,
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: expense.selectedUsersLength == 0
                          ? Center(
                              child: Text(
                                "You must select at least one person to split with.",
                                style: context.f.body3.copyWith(
                                  fontSize: 10,
                                  color: context.c.secondaryColor,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                CurrencyAmount(
                                  amount:
                                      "${expense.formattedEqualSplit}/person",
                                  style: context.f.body1,
                                ),
                                Text(
                                  "(${expense.selectedUsersLength} people)",
                                  style: context.f.body2,
                                ),
                              ],
                            ),
                    ),
                    Container(
                      height: 34,
                      width: 2,
                      color: context.c.hintColor,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "All",
                      style: context.f.body2,
                    ),
                    Checkbox(
                      value: expense.selectedUsersLength == users.length,
                      shape: const CircleBorder(),
                      onChanged: (bool? isSelected) {
                        if (isSelected == true) {
                          expense.selectAllUsers(users);
                        } else {
                          expense.removeAllUsers();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        itemCount: users.length,
        itemBuilder: (_, index) {
          return _UserTile(
            user: users[index],
          );
        },
        separatorBuilder: (_, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CustomDivider(),
          );
        },
      ),
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
        splashColor: Colors.transparent,
        onTap: () {
          if (expense.isUserSelected(user.id)) {
            expense.removeUser(user.id);
          } else {
            expense.selectUser(user.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 8,
            top: 4,
            bottom: 4,
          ),
          child: Row(
            children: [
              Avatar(
                seed: user.name,
                size: 36,
                borderRadius: BorderRadius.circular(18),
              ),
              const SizedBox(width: 16),
              Text(
                user.name,
                style: context.f.body1.copyWith(
                  fontWeight:
                      expense.isUserSelected(user.id) ? FontWeight.w600 : null,
                ),
              ),
              const Spacer(),
              Checkbox(
                value: expense.isUserSelected(user.id),
                shape: const CircleBorder(),
                onChanged: (bool? isSelected) {
                  if (isSelected == true) {
                    expense.selectUser(user.id);
                  } else {
                    expense.removeUser(user.id);
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
