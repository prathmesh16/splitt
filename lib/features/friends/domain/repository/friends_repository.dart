import 'package:splitt/features/friends/data/models/friends_dashboard_model.dart';

abstract class FriendsRepository {
  Future<FriendsDashboardModel> getFriendsDashboard(String userId);
}
