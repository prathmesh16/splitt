import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/users/data/models/user_model.dart';

class GroupModel {
  String id;
  String name;
  String description;
  List<UserModel> users;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.users,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json["groupId"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      users: json["userList"] != null
          ? (json["userList"] as List)
              .map((user) => UserModel.fromJson(user))
              .toList()
          : [],
    );
  }

  factory GroupModel.fromGroup(Group group) {
    return GroupModel(
      id: group.id,
      name: group.name,
      description: group.description,
      //Not required as of now
      users: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
    };
  }
}
