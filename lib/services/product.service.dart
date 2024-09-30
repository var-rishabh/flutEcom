import 'package:http/http.dart' as http;

import 'package:flut_mart/models/product.dart';

import 'package:flut_mart/utils/constants/endpoint.constant.dart';

class ProductApiService {
  final http.Client client;

  static const baseUrl = Endpoint.baseUrl;
  static const getProducts = Endpoint.getProducts;

  ProductApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> getAllProducts() async {
    final response = await client.get(Uri.parse(getProducts));

    if (response.statusCode == 200) {
      final Products products = productFromJson(response.body);
      List<Product> allProducts = products.products;

      return allProducts;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Product> getProductById(String id) async {
    final response = await client.get(Uri.parse(getProducts));

    if (response.statusCode == 200) {
      final Products products = productFromJson(response.body);

      return products.products
          .firstWhere((product) => product.id.toString() == id);
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Product>> getProductsByCategoryId(
      int categoryId, int page, int sort) async {
    final response = await client.get(Uri.parse(getProducts));

    // delay by 2 seconds
    await Future.delayed(const Duration(milliseconds: 200));

    if (response.statusCode == 200) {
      final Products products = productFromJson(response.body);

      List<Product> allProducts = products
          .where((product) => product.categoryId == categoryId)
          .toList();

      if (sort == 0) {
        allProducts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else if (sort == 1) {
        allProducts.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      } else if (sort == 2) {
        allProducts
            .sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
      } else if (sort == 3) {
        allProducts
            .sort((a, b) => b.discountedPrice.compareTo(a.discountedPrice));
      }

      return allProducts.skip((page - 1) * 20).take(20).toList();
    } else {
      throw Exception(response.body);
    }
  }
}
