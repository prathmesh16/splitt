import 'package:splitt/features/group/data/api/group_api_service.dart';
import 'package:splitt/features/group/data/api/group_api_service_impl.dart';
import 'package:splitt/features/group/data/models/group_dashboard_model.dart';
import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/group/domain/repository/groups_repository.dart';
import 'package:splitt/features/group/presentation/models/group.dart';

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
}
