import 'dart:convert';
import '../../models/user_model.dart';
import 'storage_service.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession({required String token, required UserModel user});
  String? getToken();
  UserModel? getCachedUser();
  bool isLoggedIn();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'cached_user';

  @override
  Future<void> saveSession({
    required String token,
    required UserModel user,
  }) async {
    final box = StorageService.authBox;
    await box.put(_tokenKey, token);
    await box.put(_userKey, jsonEncode(user.toJson()));
  }

  @override
  String? getToken() {
    return StorageService.authBox.get(_tokenKey) as String?;
  }

  @override
  UserModel? getCachedUser() {
    final raw = StorageService.authBox.get(_userKey) as String?;
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  bool isLoggedIn() => getToken() != null;

  @override
  Future<void> clearSession() async {
    final box = StorageService.authBox;
    await box.delete(_tokenKey);
    await box.delete(_userKey);
  }
}