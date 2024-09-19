import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flut_mart/models/product.dart';

// import 'package:flut_mart/utils/constants/product.constant.dart';
import 'package:flut_mart/utils/constants/endpoint.constant.dart';

class ProductApiService {
  final http.Client client;

  static const baseUrl = Endpoint.baseUrl;
  static const getProducts = Endpoint.getProducts;

  ProductApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> getAllProducts() async {
    final response = await client.get(Uri.parse(getProducts));

    if (response.statusCode == 200) {
      final products = List<Product>.from(
        jsonDecode(response.body).map(
          (x) => Product(
            id: x['id'],
            name: x['name'],
            image: x['image'],
            price: x['price'],
            discount: x['discount'],
            description: x['description'],
            categoryId: x['categoryId'],
            rating: x['rating'],
            noOfReviews: x['noOfReviews'],
          ),
        ),
      );
      return products;
    } else {
      throw Exception(response.body);
    }

    // return allProducts;
  }

  Future<Product> getProductById(String id) async {
    final response = await client.get(Uri.parse(getProducts));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Product> products = List<Product>.from(
        data["products"].map(
          (x) => Product(
            id: x['id'],
            name: x['name'],
            image: x['image'],
            price: x['price'],
            discount: x['discount'],
            description: x['description'],
            categoryId: x['categoryId'],
            rating: x['rating'],
            noOfReviews: x['noOfReviews'],
          ),
        ),
      );
      return products.firstWhere((product) => product.id.toString() == id);
    } else {
      throw Exception(response.body);
    }
    // return allProducts.firstWhere((product) => product.id.toString() == id);
  }

  Future<List<Product>> getProductsByCategoryId(
      int categoryId, int page, int sort) async {
    final response = await client.get(Uri.parse(getProducts));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<Product> products = List<Product>.from(
        data['products'].map(
          (x) => Product(
            id: x['id'],
            name: x['name'],
            image: x['image'],
            price: x['price'],
            discount: x['discount'],
            description: x['description'],
            categoryId: x['categoryId'],
            rating: x['rating'],
            noOfReviews: x['noOfReviews'],
          ),
        ),
      );

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
