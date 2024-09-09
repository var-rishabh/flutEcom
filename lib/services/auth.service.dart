import 'dart:convert';
import 'package:http/http.dart' as http;

// constants
import 'package:flut_mart/utils/constants/endpoint.constant.dart';

// models
import 'package:flut_mart/utils/models/user.model.dart';

class AuthApiService {
  final http.Client client;

  static const baseUrl = Endpoint.baseUrl;
  static const login = Endpoint.login;
  static const signup = Endpoint.signup;
  static const getUser = Endpoint.getUser;

  AuthApiService({http.Client? client}) : client = client ?? http.Client();

  // Login user
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl$login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  // SignUp user
  Future<Map<String, dynamic>> signupUser(User user) async {
    final response = await client.post(
      Uri.parse('$baseUrl$signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  // Get User Profile
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final response = await client.get(Uri.parse('https://api.escuelajs.co/api/v1/users/1'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}
