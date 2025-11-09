import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/friends/domain/repository/friends_repository.dart';
import 'package:splitt/features/friends/domain/repository/groups_repository_impl.dart';
import 'package:splitt/features/friends/presentation/models/friends_dashboard.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';

class FriendsDashboardBloc extends Cubit<UIState<FriendsDashboard>> {
  final FriendsRepository _friendsRepository;

  FriendsDashboard? dashboard;

  FriendsDashboardBloc({
    FriendsRepository? friendsRepository,
  })  : _friendsRepository = friendsRepository ?? FriendsRepositoryImpl(),
        super(const Idle());

  Future getFriendsDashboard() async {
    emit(const Loading());

    try {
      final userId = UserDataStore().userId;
      final friendsDashboardModel =
          await _friendsRepository.getFriendsDashboard(userId);
      final friendsDashboard =
          FriendsDashboard.fromFriendsDashboardModel(friendsDashboardModel);
      dashboard = friendsDashboard;
      emit(Success(friendsDashboard));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
