import 'package:splitt/features/users/presentation/models/user.dart';

class UserDataStore {
  static final UserDataStore _instance = UserDataStore._();

  UserDataStore._();

  factory UserDataStore() {
    return _instance;
  }

  final User me = const User(
    id: "u100",
    name: "Alice",
    mobile: "",
    email: "",
  );
}
