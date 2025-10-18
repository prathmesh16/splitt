import 'package:splitt/features/auth/data/api/auth_api_service.dart';
import 'package:splitt/features/auth/data/api/auth_api_service_impl.dart';
import 'package:splitt/features/auth/data/models/token_model.dart';
import 'package:splitt/features/core/domain/token_storage.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokenStorage _tokenStorage;
  final AuthAPIService _authAPIService;

  AuthRepositoryImpl({
    AuthAPIService? authAPIService,
    TokenStorage? tokenStorage,
  })  : _authAPIService = authAPIService ?? AuthAPIServiceImpl(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _authAPIService.login(
      email: email,
      password: password,
    );

    final TokenModel tokenModel = TokenModel.fromJson(response.data);

    await _tokenStorage.saveTokens(
      accessToken: tokenModel.accessToken,
      refreshToken: tokenModel.refreshToken,
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null;
  }

  @override
  Future<void> logout() async => _tokenStorage.clear();
}
