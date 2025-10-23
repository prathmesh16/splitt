import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/core/network/base_api_service.dart';
import 'package:splitt/features/group/data/api/group_api_service.dart';
import 'package:splitt/features/group/data/models/add_group_members_model.dart';
import 'package:splitt/features/group/data/models/group_model.dart';

class GroupApiServiceImpl extends BaseAPIService implements GroupAPIService {
  @override
  Future<APIResponse> getAllGroups() {
    return get('groups');
  }

  @override
  Future<APIResponse> getGroupDashboard(String userId) {
    return get("dashboard/users/$userId/groups");
  }

  @override
  Future<APIResponse> createGroup(GroupModel group) {
    return post(
      'groups',
      body: group.toJson(),
    );
  }

  @override
  Future<APIResponse> addMembersToGroup(
      String groupId, AddGroupMembersModel group) {
    return post(
      'groups/$groupId/users',
      body: group.toJson(),
    );
  }
}
