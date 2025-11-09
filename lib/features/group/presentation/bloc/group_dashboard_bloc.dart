import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/domain/repository/groups_repository.dart';
import 'package:splitt/features/group/domain/repository/groups_repository_impl.dart';
import 'package:splitt/features/group/presentation/models/group_dashboard.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';

class GroupDashboardBloc extends Cubit<UIState<GroupDashboard>> {
  final GroupsRepository _groupsRepository;

  GroupDashboard? dashboard;

  GroupDashboardBloc({
    GroupsRepository? groupsRepository,
  })  : _groupsRepository = groupsRepository ?? GroupsRepositoryImpl(),
        super(const Idle());

  Future getGroupDashboard() async {
    emit(const Loading());

    try {
      final userId = UserDataStore().userId;
      final groupDashboardModel =
          await _groupsRepository.getGroupDashboard(userId);
      final groupDashboard =
          GroupDashboard.fromGroupDashboardModel(groupDashboardModel);
      dashboard = groupDashboard;
      emit(Success(groupDashboard));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
