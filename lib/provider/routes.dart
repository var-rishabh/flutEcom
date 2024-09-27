import 'package:flutter/material.dart';

class RoutesProvider extends ChangeNotifier {
  String _currentRoute = '/';
  String _previousRoute = '/';

  String get currentRoute => _currentRoute;

  String get previousRoute => _previousRoute;

  void setCurrentRoute(String newRoute) {
    _previousRoute = _currentRoute;
    _currentRoute = newRoute;
    notifyListeners();
  }
}
