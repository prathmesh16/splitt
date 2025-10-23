import 'package:splitt/features/users/presentation/models/user.dart';

class GroupMember {
  String id;
  String name;
  String? mobile;
  String? email;
  bool isPhoneContact;

  GroupMember({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    required this.isPhoneContact,
  });

  factory GroupMember.fromUser(User user) {
    return GroupMember(
      id: user.id,
      name: user.name,
      mobile: user.mobile,
      email: user.email,
      isPhoneContact: false,
    );
  }
}
