import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/models/user.dart';
import 'package:splitt/common/utils/constants.dart';

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
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red[400],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  "₹${expense.formattedEqualSplit}/person",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text("(${expense.selectedUsersLength} people)"),
                              ],
                            ),
                    ),
                    Container(
                      height: 34,
                      width: 2,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "All",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Checkbox(
                      value: expense.selectedUsersLength == users.length,
                      activeColor: Constants.primaryColor,
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
                      expense.isUserSelected(user.id) ? FontWeight.w500 : null,
                ),
              ),
              const Spacer(),
              Checkbox(
                value: expense.isUserSelected(user.id),
                activeColor: Constants.primaryColor,
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
