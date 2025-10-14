import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/common/models/user.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/users/domain/repository/users_repository.dart';
import 'package:splitt/features/users/domain/repository/users_repository_impl.dart';

class UsersBloc extends Cubit<UIState<List<User>>> {
  final UsersRepository _usersRepository;

  UsersBloc({
    UsersRepository? usersRepository,
  })  : _usersRepository = usersRepository ?? UsersRepositoryImpl(),
        super(const Idle());

  Future getAllUsers() async {
    emit(const Loading());
    await _usersRepository.getAllUsers().then((users) {
      final usersList = users.map((user) => User.fromUserModel(user)).toList();
      emit(Success(usersList));
    }).catchError((error) {
      emit(Error(error));
    });
  }
}
