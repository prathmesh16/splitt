import 'package:splitt/features/core/models/api_response.dart';

abstract class UserAPIService {
  Future<APIResponse> getAllUsers();

  Future<APIResponse> getMyDetails();
}
