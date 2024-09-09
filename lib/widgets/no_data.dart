import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/animations/noData.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 40),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );
  }
}
