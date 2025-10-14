import 'package:splitt/features/group/data/models/group_model.dart';

class Group {
  final String id;
  final String name;

  const Group({
    required this.id,
    required this.name,
  });

  factory Group.fromGroupModel(GroupModel group) {
    return Group(
      id: group.id,
      name: group.name,
    );
  }
}
