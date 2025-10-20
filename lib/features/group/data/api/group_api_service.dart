import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/group/data/models/group_model.dart';

abstract class GroupAPIService {
  Future<APIResponse> getAllGroups();

  Future<APIResponse> getGroupDashboard(String userId);

  Future<APIResponse> createGroup(GroupModel group);
}
