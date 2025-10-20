class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String userId;

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }
}
