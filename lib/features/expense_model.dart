import 'package:splitt/common/models/expense.dart';
import 'package:splitt/features/split/models/spilt_type.dart';

class ExpenseModel {
  String? id;
  final String title;
  final String description;
  final double amount;
  final String payerId;
  final String groupId;
  final List<String> participantIds;
  final SplitType splitType;
  final Map<String, double> splitDetails;

  ExpenseModel({
    this.id,
    required this.title,
    required this.amount,
    required this.payerId,
    this.description = "",
    required this.groupId,
    required this.participantIds,
    required this.splitType,
    this.splitDetails = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "amount": amount,
      "payerId": payerId,
      //TODO : change this when backend starts sending groupId as String
      "groupId": int.parse(groupId),
      "participantIds": participantIds,
      "splitType": splitType.backendValue,
      "splitDetails": splitDetails,
    };
  }

  factory ExpenseModel.fromExpense(Expense expense) {
    return ExpenseModel(
      title: expense.name,
      description: expense.name,
      amount: expense.amount,
      payerId: expense.getPaidBy(),
      groupId: expense.groupId,
      participantIds: expense.getIncludedIds(),
      splitType: expense.splitType,
      splitDetails: expense.getSplitDetails(),
    );
  }
}
