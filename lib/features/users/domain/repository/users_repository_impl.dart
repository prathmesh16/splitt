import 'package:splitt/features/users/data/api/user_api_service.dart';
import 'package:splitt/features/users/data/api/user_api_service_impl.dart';
import 'package:splitt/features/users/data/models/user_model.dart';
import 'package:splitt/features/users/domain/repository/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UserAPIService _userAPIService;

  UsersRepositoryImpl({
    UserAPIService? userAPIService,
  }) : _userAPIService = userAPIService ?? UserAPIServiceImpl();

  @override
  Future<List<UserModel>> getAllUsers() async {
    final response = await _userAPIService.getAllUsers();
    final users = response.data as List;
    return users.map((user) => UserModel.fromJson(user)).toList();
  }

  @override
  Future<UserModel> getMyDetails() async {
    final response = await _userAPIService.getMyDetails();
    return UserModel.fromJson(response.data);
  }
}
