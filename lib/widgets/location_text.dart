import 'package:flutter/material.dart';

class LocationText extends StatelessWidget {
  const LocationText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_pin,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 5),
        Text(
          'Deliver to ',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        Text(
          'Hitech City, Hyderabad',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 20,
        ),
      ],
    );
  }
}
