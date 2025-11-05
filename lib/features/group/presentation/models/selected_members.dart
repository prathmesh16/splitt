import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:splitt/features/group/presentation/models/group_member.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class SelectedMembers extends ChangeNotifier {
  final String groupId;
  final Map<String, GroupMember> _users = {};
  final Map<String, GroupMember> _alreadyMembers = {};

  SelectedMembers({
    required this.groupId,
    required List<User> alreadyMembers,
  }) {
    for (var member in alreadyMembers) {
      _alreadyMembers[member.id] = GroupMember.fromUser(member);
    }
  }

  void addUser(GroupMember user) {
    _users.addAll({user.id: user});
    notifyListeners();
  }

  void removeUser(GroupMember user) {
    _users.remove(user.id);
    notifyListeners();
  }

  bool isUserSelected(GroupMember user) {
    return _users[user.id] != null;
  }

  int get length => _users.length;

  List<GroupMember> get usersList => _users.values.toList();

  bool isUserAlreadyMember(GroupMember user) {
    return _alreadyMembers[user.id] != null;
  }
}
