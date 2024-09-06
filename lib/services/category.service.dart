import 'dart:convert';
import 'package:http/http.dart' as http;

// constants
import 'package:flut_mart/utils/constants/category.constant.dart';
import 'package:flut_mart/utils/constants/endpoint.constant.dart';

// models
import 'package:flut_mart/utils/models/category.model.dart';

class CategoryApiService {
  final http.Client client;

  static const baseUrl = Endpoint.baseUrl;
  static const categories = Endpoint.getCategories;

  CategoryApiService({http.Client? client}) : client = client ?? http.Client();

  // Get all categories
  Future<List<Category>> getCategories() async {
    // final response = await client.get(Uri.parse('$baseUrl$categories'));

    // if (response.statusCode == 200) {
    //   return List<Category>.from(
    //     jsonDecode(response.body).map(
    //       (x) => Category(
    //         id: x['id'],
    //         name: x['name'],
    //         image: x['image'],
    //       ),
    //     ),
    //   );
    // } else {
    //   throw Exception(response.body);
    // }

    //return data after 3 seconds
    return allCategories;
  }
}
