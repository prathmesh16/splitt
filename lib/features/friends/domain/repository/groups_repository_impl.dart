import 'package:splitt/features/friends/data/api/friends_api_service.dart';
import 'package:splitt/features/friends/data/api/friends_api_service_impl.dart';
import 'package:splitt/features/friends/data/models/friends_dashboard_model.dart';
import 'package:splitt/features/friends/domain/repository/friends_repository.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsApiService _friendsApiService;

  FriendsRepositoryImpl({
    FriendsApiService? friendsApiService,
  }) : _friendsApiService = friendsApiService ?? FriendsApiServiceImpl();

  @override
  Future<FriendsDashboardModel> getFriendsDashboard(String userId) async {
    final response = await _friendsApiService.getFriendsDashboard(userId);
    return FriendsDashboardModel.fromJson(response.data);
  }
}
