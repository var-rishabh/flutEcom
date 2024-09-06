import 'package:flutter/material.dart';

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
              child: Image.asset(
                image,
                width: boxSize * 0.7,
                height: boxSize * 0.7,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
