import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';
import 'package:splitt/features/users/presentation/models/user.dart';
import 'package:splitt/features/core/models/ui_state.dart';
import 'package:splitt/features/users/domain/repository/users_repository.dart';
import 'package:splitt/features/users/domain/repository/users_repository_impl.dart';

class MyDetailsBloc extends Cubit<UIState<User>> {
  final UsersRepository _usersRepository;

  MyDetailsBloc({
    UsersRepository? usersRepository,
  })  : _usersRepository = usersRepository ?? UsersRepositoryImpl(),
        super(const Idle());

  Future getMyDetails() async {
    emit(const Loading());
    try {
      final userModel = await _usersRepository.getMyDetails();
      final user = User.fromUserModel(userModel);
      UserDataStore().me = user;
      emit(Success(user));
    } catch (e) {
      emit(Failure(e as Error));
    }
  }
}
