import 'package:splitt/features/auth/data/api/auth_api_service.dart';
import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/core/network/base_api_service.dart';

class AuthAPIServiceImpl extends BaseAPIService implements AuthAPIService {
  AuthAPIServiceImpl() : super(requiresAuth: false);

  @override
  Future<APIResponse> login({
    required String email,
    required String password,
  }) {
    return post(
      'auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );
  }
}
