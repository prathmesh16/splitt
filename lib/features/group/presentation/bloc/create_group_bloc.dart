import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/group/domain/repository/groups_repository.dart';
import 'package:splitt/features/group/domain/repository/groups_repository_impl.dart';
import 'package:splitt/features/group/presentation/models/group.dart';

class CreateGroupBloc extends Cubit<UIState> {
  final GroupsRepository _groupsRepository;

  CreateGroupBloc({
    GroupsRepository? groupsRepository,
  })  : _groupsRepository = groupsRepository ?? GroupsRepositoryImpl(),
        super(const Idle());

  Future createGroup(Group group) async {
    emit(const Loading());
    try {
      await _groupsRepository.createGroup(group);
      emit(const Success(true));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
