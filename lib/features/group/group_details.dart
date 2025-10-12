import 'package:flutter/material.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/models/user.dart';
import 'package:splitt/features/split/views/expense_provider.dart';
import 'package:splitt/features/split/views/new_split.dart';

class GroupDetails extends StatelessWidget {
  GroupDetails({super.key});

  final List<User> users = [
    const User(
      id: "1",
      name: "Prathmesh",
    ),
    const User(
      id: "2",
      name: "Yash",
    ),
    const User(
      id: "3",
      name: "Sarvesh",
    ),
    const User(
      id: "4",
      name: "Saurabh",
    ),
    const User(
      id: "5",
      name: "Omkar",
    ),
    const User(
      id: "6",
      name: "Abhijeet",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExpenseProvider(
                expense: Expense(
                  users: users,
                ),
                child: const NewSplit(),
              ),
            ),
          );
        },
        child: const Icon(Icons.sticky_note_2_outlined),
      ),
    );
  }
}
