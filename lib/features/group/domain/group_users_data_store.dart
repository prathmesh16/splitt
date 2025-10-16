import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:collection/collection.dart';

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

  User? getUser(String userId) {
    return users.firstWhereOrNull((user) => user.id == userId);
  }
}
