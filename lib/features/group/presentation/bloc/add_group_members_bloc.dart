import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/domain/repository/groups_repository.dart';
import 'package:splitt/features/group/domain/repository/groups_repository_impl.dart';
import 'package:splitt/features/group/presentation/models/selected_members.dart';

class AddGroupMembersBloc extends Cubit<UIState> {
  final GroupsRepository _groupsRepository;

  AddGroupMembersBloc({
    GroupsRepository? groupsRepository,
  })  : _groupsRepository = groupsRepository ?? GroupsRepositoryImpl(),
        super(const Idle());

  Future addMembersToGroup(
      String groupId, SelectedMembers selectedMembers) async {
    emit(const Loading());
    try {
      await _groupsRepository.addMembersToGroup(groupId, selectedMembers);
      emit(const Success(true));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
