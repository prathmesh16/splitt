import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/group/data/models/add_group_members_model.dart';
import 'package:splitt/features/group/data/models/group_model.dart';

abstract class GroupAPIService {
  Future<APIResponse> getAllGroups();

  Future<APIResponse> getGroupDashboard(String userId);

  Future<APIResponse> createGroup(GroupModel group);

  Future<APIResponse> addMembersToGroup(
      String groupId, AddGroupMembersModel group);
}
