import 'package:flutter/material.dart';

import 'package:flut_mart/models/category.dart';
import 'package:flut_mart/services/category.service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryApiService _categoryApiService = CategoryApiService();

  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Category> get categories => _categories;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    try {
      _categories = await _categoryApiService.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
