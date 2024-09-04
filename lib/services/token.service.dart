import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _tokenKey = 'jwt_token';
  
  // Store JWT Token in SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get JWT Token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove JWT Token from SharedPreferences
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Decode JWT Token
  static Map<String, dynamic>? decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) {
      return false;
    }
    final decodedToken = decodeToken(token);
    return decodedToken != null && !JwtDecoder.isExpired(token);
  }
}
