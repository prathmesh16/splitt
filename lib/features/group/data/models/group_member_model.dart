import 'package:splitt/features/group/presentation/models/group_member.dart';

class GroupMemberModel {
  final String? id;
  final String name;
  final String? mobile;
  final String? email;

  GroupMemberModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
  });

  factory GroupMemberModel.fromGroupMember(GroupMember member) {
    return GroupMemberModel(
      id: !member.isPhoneContact ? member.id : null,
      name: member.name,
      mobile: member.mobile,
      email: member.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      //TODO : remove userId key when backend fix bug in group users
      "userId": id,
      "name": name,
      "mobile": mobile,
      "email": email,
    };
  }
}
