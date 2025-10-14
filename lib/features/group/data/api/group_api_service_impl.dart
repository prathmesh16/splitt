import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/core/network/base_api_service.dart';
import 'package:splitt/features/group/data/api/group_api_service.dart';

class GroupApiServiceImpl extends BaseAPIService implements GroupAPIService {
  @override
  Future<APIResponse> getAllGroups() async {
    return get('groups');
  }
}
