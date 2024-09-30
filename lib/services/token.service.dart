import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _tokenKey = 'access_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Map<String, dynamic>? decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) {
      return false;
    }
    final decodedToken = decodeToken(token);
    return decodedToken != null && !JwtDecoder.isExpired(token);
  }
}
