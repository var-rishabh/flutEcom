import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'package:flut_mart/utils/constants/category.constant.dart';
import 'package:flut_mart/utils/constants/endpoint.constant.dart';
import 'package:flut_mart/models/category.dart';

class CategoryApiService {
  final http.Client client;

  static const categories = Endpoint.getCategories;

  CategoryApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Category>> getCategories() async {
    final response = await client.get(Uri.parse(categories));
    if (response.statusCode == 200) {
      final ProductCategory categories = productCategoryFromJson(response.body);
      List<Category> allCategories = categories.categories;

      return allCategories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Category> getCategoryById(int id) async {
    final response = await client.get(Uri.parse(categories));
    if (response.statusCode == 200) {
      final ProductCategory categories = productCategoryFromJson(response.body);

      return categories.categories.firstWhere((category) => category.id == id);
    } else {
      throw Exception('Failed to load category');
    }
  }
}
