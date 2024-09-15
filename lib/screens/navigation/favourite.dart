import 'package:flutter/material.dart';

import 'package:flut_mart/utils/helper/responsive.dart';
import 'package:flut_mart/utils/models/product.model.dart';

import 'package:flut_mart/services/favourite.service.dart';
import 'package:flut_mart/widgets/no_data.dart';
import 'package:flut_mart/services/product.service.dart';


import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/product_card.dart';

class FavoritesScreen extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const FavoritesScreen({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  final ProductApiService _productApiService = ProductApiService();
  List<Product> _favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final List<String> favoriteIds = await _favoritesService.getFavorites();
    final List<Product> products = await Future.wait(
        favoriteIds.map((id) => _productApiService.getProductById(id)));
    setState(() {
      _favoriteItems = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.symmetric(horizontal: 100, vertical: 40)
                : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Favorites',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    KIconButton(
                      icon: Icons.home,
                      isActive: widget.currentIndex == 0,
                      onTap: () => widget.onTabSelected(0),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Responsive.isDesktop(context)
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 50,
                          mainAxisExtent: 270,
                        ),
                        itemCount: _favoriteItems.length,
                        itemBuilder: (context, index) {
                          final Product product =
                              _favoriteItems.toList()[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-details',
                                arguments: {
                                  'productId': product.id,
                                  'currentIndex': widget.currentIndex,
                                  'onTabSelected': widget.onTabSelected,
                                },
                              );
                            },
                          );
                        },
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 270,
                        ),
                        itemCount: _favoriteItems.length,
                        itemBuilder: (context, index) {
                          final Product product =
                              _favoriteItems.toList()[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-details',
                                arguments: {
                                  'productId': product.id,
                                  'currentIndex': widget.currentIndex,
                                  'onTabSelected': widget.onTabSelected,
                                },
                              );
                            },
                          );
                        },
                      ),
                if (_favoriteItems.isEmpty) const NoData()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
