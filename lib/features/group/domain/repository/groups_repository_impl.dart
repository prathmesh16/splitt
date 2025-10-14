import 'package:splitt/features/group/data/api/group_api_service.dart';
import 'package:splitt/features/group/data/api/group_api_service_impl.dart';
import 'package:splitt/features/group/data/models/group_model.dart';
import 'package:splitt/features/group/domain/repository/groups_repository.dart';

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
}
