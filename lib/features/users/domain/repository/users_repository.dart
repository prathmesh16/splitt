import 'package:splitt/features/users/data/models/user_model.dart';

abstract class UsersRepository {
  Future<List<UserModel>> getAllUsers();
}
