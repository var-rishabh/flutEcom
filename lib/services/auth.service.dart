import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flut_mart/models/user.dart';
import 'package:flut_mart/utils/constants/endpoint.constant.dart';

class AuthApiService {
  final http.Client client;

  static const baseUrl2 = Endpoint.baseUrl2;

  static const login = Endpoint.login;
  static const signup = Endpoint.signup;
  static const getUser = Endpoint.getUser;

  AuthApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl2$login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
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

  Future<Map<String, dynamic>> signupUser(User user) async {
    final response = await client.post(
      Uri.parse('$baseUrl2$signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final response = await client.get(Uri.parse('$baseUrl2/users/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}
