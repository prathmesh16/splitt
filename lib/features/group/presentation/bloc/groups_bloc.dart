import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/group/presentation/models/group.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/domain/repository/groups_repository.dart';
import 'package:splitt/features/group/domain/repository/groups_repository_impl.dart';

class GroupsBloc extends Cubit<UIState<List<Group>>> {
  final GroupsRepository _groupsRepository;

  GroupsBloc({
    GroupsRepository? groupsRepository,
  })  : _groupsRepository = groupsRepository ?? GroupsRepositoryImpl(),
        super(const Idle());

  Future getAllGroups() async {
    emit(const Loading());

    try {
      final groups = await _groupsRepository.getAllGroups();
      final groupsList = groups.map((g) => Group.fromGroupModel(g)).toList();
      emit(Success(groupsList));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
