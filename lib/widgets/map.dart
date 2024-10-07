import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flut_mart/provider/location.dart';

class KMap extends StatelessWidget {
  const KMap({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: LatLng(
          locationProvider.position.latitude,
          locationProvider.position.longitude,
        ),
        maxZoom: 18.0,
        minZoom: 2.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.flut_mart',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(
                locationProvider.position.latitude,
                locationProvider.position.longitude,
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.black54,
                size: 30.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
