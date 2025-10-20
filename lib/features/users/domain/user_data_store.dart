import 'package:splitt/features/core/domain/token_storage.dart';
import 'package:splitt/features/users/presentation/models/user.dart';

class UserDataStore {
  static final UserDataStore _instance = UserDataStore._();

  UserDataStore._();

  factory UserDataStore() {
    return _instance;
  }

  late String userId;

  User? me;

  void clearData() {
    userId = "";
    me = null;
  }
}
