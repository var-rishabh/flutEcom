import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flut_mart/provider/location.dart';

class LocationText extends StatelessWidget {
  const LocationText({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context);

    return Row(
      children: [
        Tooltip(
          message: 'Tap to update location.',
          child: InkWell(
            onTap: () {
              locationProvider.getCurrentLocation();
            },
            child: locationProvider.isLoading
                ? const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      if (locationProvider.address.isEmpty)
                        Text(
                          ' Click to get your location',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          Provider.of<LocationProvider>(context).address,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        if (locationProvider.address.isNotEmpty)
          const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
          ),
      ],
    );
  }
}
