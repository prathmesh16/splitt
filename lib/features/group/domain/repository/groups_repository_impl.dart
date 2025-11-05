import 'package:splitt/features/group/data/api/group_api_service.dart';
import 'package:splitt/features/group/data/api/group_api_service_impl.dart';
import 'package:splitt/features/group/data/models/add_group_members_model.dart';
import 'package:splitt/features/group/data/models/group_dashboard_model.dart';
import 'package:splitt/features/group/data/models/group_member_model.dart';
import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/group/domain/repository/groups_repository.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/group/presentation/models/group_member.dart';
import 'package:splitt/features/group/presentation/models/selected_members.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupAPIService _groupAPIService;

  GroupsRepositoryImpl({
    GroupAPIService? groupAPIService,
  }) : _groupAPIService = groupAPIService ?? GroupApiServiceImpl();

  @override
  Future<List<GroupModel>> getAllGroups() async {
    final response = await _groupAPIService.getAllGroups();
    final groups = response.data as List;
    return groups.map((group) => GroupModel.fromJson(group)).toList();
  }

  @override
  Future<GroupDashboardModel> getGroupDashboard(String userId) async {
    final response = await _groupAPIService.getGroupDashboard(userId);
    return GroupDashboardModel.fromJson(response.data);
  }

  @override
  Future createGroup(Group group) {
    return _groupAPIService.createGroup(GroupModel.fromGroup(group));
  }

  @override
  Future addMembersToGroup(String groupId, SelectedMembers model) {
    final group = AddGroupMembersModel(
      members: model.usersList
          .map((member) => GroupMemberModel.fromGroupMember(member))
          .toList(),
    );
    return _groupAPIService.addMembersToGroup(groupId, group);
  }
}
