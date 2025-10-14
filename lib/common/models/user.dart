import 'package:splitt/features/users/data/models/user_model.dart';

class User {
  final String id;
  final String name;

  const User({
    required this.id,
    required this.name,
  });

  factory User.fromUserModel(UserModel user) {
    return User(
      id: user.id,
      name: user.name,
    );
  }
}
