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
      //TODO : remove userId key when backend fix bug in group users
      id: json["id"] ?? json["userId"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
    );
  }
}
