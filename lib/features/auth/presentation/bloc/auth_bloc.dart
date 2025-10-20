import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/auth/domain/auth_repository.dart';
import 'package:splitt/features/auth/domain/auth_repository_impl.dart';
import 'package:splitt/features/users/domain/user_data_store.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      error: error,
    );
  }
}

class AuthBloc extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({
    AuthRepository? authRepository,
  })  : _authRepository = authRepository ?? AuthRepositoryImpl(),
        super(const AuthState());

  Future<bool> checkLoginStatus() async {
    final loggedIn = await _authRepository.isLoggedIn();
    await _setUserId();
    emit(state.copyWith(isLoggedIn: loggedIn));
    return loggedIn;
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _authRepository.login(email: email, password: password);
      await _setUserId();
      emit(state.copyWith(isLoading: false, isLoggedIn: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _setUserId() async {
    UserDataStore().userId = (await _authRepository.getUserId()) ?? "";
  }

  Future<void> logout() async {
    await _authRepository.logout();
    UserDataStore().clearData();
    emit(state.copyWith(isLoggedIn: false));
  }
}
