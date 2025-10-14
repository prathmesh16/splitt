import 'package:splitt/features/users/presentation/models/user.dart';

class GroupUsersDataStore {
  static final GroupUsersDataStore _instance = GroupUsersDataStore._();

  GroupUsersDataStore._();

  factory GroupUsersDataStore() {
    return _instance;
  }

  List<User> users = [];
  String groupId = "";

  void clearData() {
    users.clear();
    groupId = "";
  }
}
