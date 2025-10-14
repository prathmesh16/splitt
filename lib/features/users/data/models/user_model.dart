class UserModel {
  String id;
  String name;
  String email;
  String mobile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
    );
  }
}
