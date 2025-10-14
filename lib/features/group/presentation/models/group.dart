import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class Group {
  final String id;
  final String name;
  final String description;
  final List<User> users;

  const Group({
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
}
