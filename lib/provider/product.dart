import 'package:flutter/material.dart';

import 'package:flut_mart/models/product.dart';
import 'package:flut_mart/services/product.service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApiService _productApiService = ProductApiService();

  List<Product> _products = [];
  List<Product> _recentProducts = [];
  List<String> _searchHistory = [];
  late Product _product;
  bool _isLoading = false;
  bool _hasMoreProducts = false;
  String _errorMessage = '';

  Product get product => _product;

  List<Product> get products => _products;

  List<Product> get recentProducts => _recentProducts;

  List<String> get searchHistory => _searchHistory;

  bool get hasMoreProducts => _hasMoreProducts;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> fetchAllProducts(searchQuery) async {
    _isLoading = true;
    try {
      _products = await _productApiService.getAllProducts(searchQuery);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

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
    notifyListeners();
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

  Future<void> fetchRecentProducts() async {
    _isLoading = true;
    try {
      _recentProducts = await _productApiService.getRecentlyViewed();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToRecentlyViewed(String productId) async {
    await _productApiService.addToRecentlyViewed(productId);
    notifyListeners();
  }

  Future<void> clearRecentProducts() async {
    await _productApiService.clearRecentlyViewed();
    notifyListeners();
  }

  Future<void> addToSearchHistory(String searchQuery) async {
    await _productApiService.addToSearchHistory(searchQuery);
    notifyListeners();
  }

  Future<void> fetchSearchHistory() async {
    _isLoading = true;
    try {
      _searchHistory = await _productApiService.getSearchHistory();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeSingleSearchHistory(String searchQuery) async {
    await _productApiService.removeSingleSearchHistory(searchQuery);
    notifyListeners();
  }

  Future<void> clearSearchHistory() async {
    await _productApiService.clearSearchHistory();
    notifyListeners();
  }
}
