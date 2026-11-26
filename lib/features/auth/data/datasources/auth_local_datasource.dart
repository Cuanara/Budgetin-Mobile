import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(AppConstants.tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await prefs.remove(AppConstants.tokenKey);
  }
}