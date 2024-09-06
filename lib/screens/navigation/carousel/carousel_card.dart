import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final Function() onPressed;

  const CarouselCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 180,
        ),
        const SizedBox(height: 15),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: Text("Shop Now",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
