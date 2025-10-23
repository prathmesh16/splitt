import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class Group {
  final String id;
  String name;
  String description;
  final List<User> users;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.users,
  });

  factory Group.fromGroupModel(GroupModel group) {
    return Group(
      id: group.id,
      name: group.name,
      description: group.description,
      users: group.users.map((user) => User.fromUserModel(user)).toList(),
    );
  }

  bool shouldShowAddMembersButton() {
    return users.where((user) => user.id != UserDataStore().userId).isEmpty;
  }
}
