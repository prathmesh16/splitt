import 'package:splitt/features/core/models/api_response.dart';

abstract class FriendsApiService {
  Future<APIResponse> getFriendsDashboard(String userId);
}
