import 'package:splitt/features/group/data/models/group_dashboard_model.dart';
import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/group/presentation/models/selected_members.dart';

abstract class GroupsRepository {
  Future<List<GroupModel>> getAllGroups();

  Future<GroupDashboardModel> getGroupDashboard(String userId);

  Future createGroup(Group group);

  Future addMembersToGroup(String groupId, SelectedMembers members);
}
