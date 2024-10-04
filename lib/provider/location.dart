import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flut_mart/services/location.service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  late Position _position;
  String _address = '';
  bool _isLoading = false;

  Position get position => _position;

  String get address => _address;

  bool get isLoading => _isLoading;

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();
    try {
      _position = await _locationService.getCurrentLocation();
      _address = await _locationService.getAddressFromPosition(_position);
    } catch (e) {
      _address = '';
    }
    _isLoading = false;
    notifyListeners();
  }
}
