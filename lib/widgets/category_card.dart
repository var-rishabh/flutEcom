import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/utils/helper/responsive.dart';

List<Color> colors = [
  Colors.red.shade50,
  Colors.blue.shade50,
  Colors.green.shade50,
];

class CategoryCard extends StatelessWidget {
  final int id;
  final String title;
  final String image;
  final double boxSize;

  const CategoryCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    this.boxSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: OutlinedButton(
        autofocus: false,
        onPressed: () {
          context.go(
            '/category/$id',
            extra: id,
          );
          print(Provider.of<RoutesProvider>(
            context,
          ).currentRoute);
          print(Provider.of<RoutesProvider>(
            context,
          ).previousRoute);
          Provider.of<RoutesProvider>(
            context,
          ).setCurrentRoute('/category/$id');
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                color: colors[id % colors.length],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Image.network(
                  image,
                  width: boxSize * 0.7,
                  height: boxSize * 0.7,
                ),
              ),
            ),
            Responsive.isDesktop(context)
                ? const SizedBox(height: 10)
                : const SizedBox(height: 5),
            Text(
              title,
              style: Responsive.isDesktop(context)
                  ? Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      )
                  : Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
