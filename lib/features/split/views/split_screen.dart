import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitt/common/custom_divider.dart';
import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/models/user.dart';
import 'package:splitt/common/utils/constants.dart';
import 'package:splitt/features/split/views/adjustment_split.dart';
import 'package:splitt/features/split/views/amount_split.dart';
import 'package:splitt/features/split/views/equal_split.dart';
import 'package:splitt/features/split/views/expense_provider.dart';
import 'package:splitt/features/split/models/spilt_type.dart';
import 'package:collection/collection.dart' show ListExtensions;
import 'package:splitt/features/split/views/percentage_split.dart';
import 'package:splitt/features/split/views/share_split.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen>
    with SingleTickerProviderStateMixin {
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

  late TabController _tabController;
  late Expense _expense;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: SplitType.values.length,
      vsync: this,
    );
    _expense = Expense(
      amount: 100,
      users: users,
    );
  }

  bool _isTabSelected(SplitType type) {
    return _expense.splitType == type;
  }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Text(
                    "Split options",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  CustomDivider(
                    color: Colors.grey[200],
                  ),
                  Expanded(
                    child: ExpenseProvider(
                      expense: _expense,
                      child: Consumer<Expense>(
                        builder: (context, expense, _) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: SplitType.values
                                    .mapIndexed(
                                      (index, type) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: InkWell(
                                          onTap: () {
                                            _tabController.animateTo(index);
                                            expense.splitType = type;
                                          },
                                          child: Container(
                                            width: 66,
                                            height: 28,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: _isTabSelected(type)
                                                  ? Constants.primaryColor
                                                  : null,
                                              border: Border.all(
                                                color: const Color(0xFFacb0af),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 2,
                                              ),
                                              child: type.tab,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    EqualSplit(
                                      users: users,
                                    ),
                                    AmountSplit(
                                      users: users,
                                    ),
                                    PercentageSplit(
                                      users: users,
                                    ),
                                    ShareSplit(
                                      users: users,
                                    ),
                                    AdjustmentSplit(
                                      users: users,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
