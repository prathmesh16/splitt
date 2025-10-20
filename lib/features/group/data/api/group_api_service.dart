import 'package:splitt/features/core/models/api_response.dart';

abstract class GroupAPIService {
  Future<APIResponse> getAllGroups();

  Future<APIResponse> getGroupDashboard(String userId);
}
