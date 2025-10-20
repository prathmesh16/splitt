import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:splitt/features/auth/data/models/token_model.dart';

class TokenStorage {
  static const _accessKey = 'accessToken';
  static const _refreshKey = 'refreshToken';
  static const _userIdKey = 'userId';

  final _storage = const FlutterSecureStorage();
  
  Future<void> saveToken({
    required TokenModel tokenModel,
  }) async {
    await _storage.write(key: _accessKey, value: tokenModel.accessToken);
    await _storage.write(key: _refreshKey, value: tokenModel.refreshToken);
    await _storage.write(key: _userIdKey, value: tokenModel.userId);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshKey);

  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
