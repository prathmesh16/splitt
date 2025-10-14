import 'package:splitt/features/core/models/api_response.dart';
import 'package:splitt/features/core/network/base_api_service.dart';
import 'package:splitt/features/users/data/api/user_api_service.dart';

class UserAPIServiceImpl extends BaseAPIService implements UserAPIService {
  @override
  Future<APIResponse> getAllUsers() async {
    return await get('users');
  }
}
