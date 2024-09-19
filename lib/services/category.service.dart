import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'package:flut_mart/utils/constants/category.constant.dart';
import 'package:flut_mart/utils/constants/endpoint.constant.dart';
import 'package:flut_mart/models/category.dart';

class CategoryApiService {
  final http.Client client;

  static const categories = Endpoint.getCategories;

  CategoryApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<ProductCategory>> getCategories() async {
    final response = await client.get(Uri.parse(categories));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<ProductCategory> categories = List<ProductCategory>.from(
        data['categories'].map(
          (category) => ProductCategory(
              id: category['id'],
              name: category['name'],
              image: category['image']),
        ),
      );
      categories.sort((a, b) => a.name.compareTo(b.name));
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }

    // return allCategories;
  }
}
