abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<bool> isLoggedIn();

  Future<void> logout();
}
