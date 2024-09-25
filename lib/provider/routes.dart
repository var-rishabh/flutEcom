import 'package:flutter/material.dart';
// create a provider to manage the current route and the previous route

class RoutesProvider extends ChangeNotifier {
  String _currentRoute = '/';
  String _previousRoute = '/';

  String get currentRoute => _currentRoute;

  String get previousRoute => _previousRoute;

  void setCurrentRoute(String route) {
    _previousRoute = _currentRoute;
    _currentRoute = route;
    notifyListeners();
  }
}
