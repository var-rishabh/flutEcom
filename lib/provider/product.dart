import 'package:flutter/material.dart';

import 'package:flut_mart/models/product.dart';
import 'package:flut_mart/services/product.service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApiService _productApiService = ProductApiService();

  List<Product> _products = [];
  late Product _product;
  bool _isLoading = false;
  bool _hasMoreProducts = false;
  String _errorMessage = '';

  Product get product => _product;

  List<Product> get products => _products;

  bool get hasMoreProducts => _hasMoreProducts;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> fetchProductByCategory(categoryId, page, sort) async {
    _isLoading = true;
    try {
      List<Product> products = await _productApiService.getProductsByCategoryId(
        categoryId,
        page,
        sort,
      );

      if (products.length == 20) {
        _hasMoreProducts = true;
      } else {
        _hasMoreProducts = false;
      }

      if (page == 1) {
        _products = products;
      } else {
        _products.addAll(products);
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    // notifyListeners();
  }

  Future<void> fetchProductById(String id) async {
    _isLoading = true;
    try {
      _product = await _productApiService.getProductById(id);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
