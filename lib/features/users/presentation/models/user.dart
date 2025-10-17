import 'package:splitt/features/users/data/models/user_model.dart';

class User {
  final String id;
  final String name;
  final String mobile;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
  });

  factory User.fromUserModel(UserModel user) {
    return User(
      id: user.id,
      name: user.name,
      mobile: user.mobile,
      email: user.email,
    );
  }
}
