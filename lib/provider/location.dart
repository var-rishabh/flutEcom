import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flut_mart/services/location.service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  late Position _position;
  Map<String, String> _address = {
    'street': '',
    'subLocality': '',
    'locality': '',
    'administrativeArea': '',
    'postalCode': '',
    'country': '',
  };

  bool _isLoading = false;

  Position get position => _position;

  Map<String, String> get address => _address;

  bool get isLoading => _isLoading;

  Future<void> getCurrentLocation() async {
    _isLoading = true;
    notifyListeners();
    try {
      _position = await _locationService.getCurrentLocation();
      _address = await _locationService.getAddressFromPosition(_position);
    } catch (e) {
      _address = {
        'street': '',
        'subLocality': '',
        'locality': '',
        'administrativeArea': '',
        'postalCode': '',
        'country': '',
      };
    }
    _isLoading = false;
    notifyListeners();
  }
}
