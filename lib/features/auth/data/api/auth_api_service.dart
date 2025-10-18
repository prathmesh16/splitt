import 'package:splitt/features/core/models/api_response.dart';

abstract class AuthAPIService {
  Future<APIResponse> login({
    required String email,
    required String password,
  });
}
