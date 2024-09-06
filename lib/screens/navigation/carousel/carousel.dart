import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flut_mart/screens/navigation/carousel/carousel_card.dart';

class KCarousel extends StatefulWidget {
  const KCarousel({super.key});

  @override
  State<KCarousel> createState() => _KCarouselState();
}

class _KCarouselState extends State<KCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      // width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 360,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: [
              CarouselCard(
                title: 'New Watch Collection',
                subtitle: 'Up to 50% off for the new customers.',
                image: 'assets/images/carousel1.png',
                onPressed: () {},
              ),
              CarouselCard(
                title: 'New Samsung Galaxy S22+ Ultra',
                subtitle: 'With 100x digital zoom and 8K video recording.',
                image: 'assets/images/carousel2.png',
                onPressed: () {},
              ),
              CarouselCard(
                title: 'Upcoming Winter Sale',
                subtitle: 'Up to 70% off on all electronics.',
                image: 'assets/images/carousel3.png',
                onPressed: () {},
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Container(
                    width: _current == i ? 30 : 10,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius:
                          _current == i ? BorderRadius.circular(5) : null,
                      shape:
                          _current == i ? BoxShape.rectangle : BoxShape.circle,
                      color: _current == i ? Colors.white : Colors.white38,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
