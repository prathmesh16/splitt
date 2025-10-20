import 'package:splitt/common/models/expense.dart';
import 'package:splitt/common/utils/utils.dart';
import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/split/models/spilt_type.dart';
import 'package:splitt/features/users/data/models/user_model.dart';

class ExpenseModel {
  String? id;
  final String title;
  final String description;
  final double amount;
  final String payerId;
  UserModel? paidBby;
  final String groupId;
  final List<String> participantIds;
  final SplitType splitType;
  final Map<String, dynamic> splitDetails;
  final Map<String, double> shares;
  final bool isSettleUp;
  final DateTime? timeStamp;

  ExpenseModel({
    this.id,
    required this.title,
    required this.amount,
    required this.payerId,
    this.paidBby,
    this.description = "",
    required this.groupId,
    required this.participantIds,
    required this.splitType,
    this.splitDetails = const {},
    this.shares = const {},
    this.isSettleUp = false,
    this.timeStamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "amount": amount,
      "payerId": payerId,
      "groupId": groupId,
      "participantIds": participantIds,
      "splitType": splitType.backendValue,
      "splitDetails": splitDetails,
      "isSettleUp": isSettleUp,
    };
  }

  factory ExpenseModel.fromExpense(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.name,
      description: expense.name,
      amount: expense.amount,
      payerId: expense.getPaidByID(),
      groupId: expense.groupId,
      participantIds: expense.getIncludedIds(),
      splitType: expense.splitType,
      splitDetails: expense.getSplitDetails(),
      isSettleUp: expense.isSettleUp,
    );
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      amount: json["amount"] ?? 0,
      payerId: json["payer"]?["userId"] ?? "",
      paidBby: UserModel.fromJson(json["payer"] ?? {}),
      groupId: json["groupId"] ?? "",
      participantIds: (json["participants"] as List)
          .map<String>((user) => user["userId"])
          .toList(),
      splitType: SplitType.fromString(json["splitType"]),
      shares: Utils.convertMapValuesToType<double>(json['shares']),
      splitDetails: json["splitDetails"] ?? {},
      isSettleUp: json["isSettleUp"] ?? false,
      timeStamp:
          json["timestamp"] != null ? DateTime.parse(json["timestamp"]) : null,
    );
  }
}
