import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/core/network/base_api_service.dart';
import 'package:splitt/features/friends/data/api/friends_api_service.dart';

class FriendsApiServiceImpl extends BaseAPIService
    implements FriendsApiService {
  @override
  Future<APIResponse> getFriendsDashboard(String userId) {
    return get("dashboard/users/$userId/friends");
  }
}
