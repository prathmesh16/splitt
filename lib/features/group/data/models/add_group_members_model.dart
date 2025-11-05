import 'package:splitt/features/group/data/models/group_member_model.dart';

class AddGroupMembersModel {
  final List<GroupMemberModel> members;

  const AddGroupMembersModel({
    required this.members,
  });

  Map<String, dynamic> toJson() {
    return {
      "members": members.map((member) => member.toJson()).toList(),
    };
  }
}
