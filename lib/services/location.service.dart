import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Map<String, String>> getAddressFromPosition(Position position) async {
    final placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final placeMark = placeMarks.first;

    return {
      'street': placeMark.street.toString(),
      'subLocality': placeMark.subLocality.toString(),
      'locality': placeMark.locality.toString(),
      'administrativeArea': placeMark.administrativeArea.toString(),
      'postalCode': placeMark.postalCode.toString(),
      'country': placeMark.country.toString(),
    };
  }
}
