import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/models/product.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/utils/helper/responsive.dart';

import 'package:flut_mart/services/favourite.service.dart';
import 'package:flut_mart/widgets/no_data.dart';
import 'package:flut_mart/services/product.service.dart';

import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/product_card.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
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
    final RoutesProvider routesProvider = Provider.of<RoutesProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Responsive.isDesktop(context)
                        ? Row(
                            children: [
                              KIconButton(
                                icon: Icons.home,
                                isActive: false,
                                onTap: () => {
                                  context.go(KRoutes.home),
                                  routesProvider.setCurrentRoute(KRoutes.home),
                                },
                              ),
                              const Icon(Icons.arrow_forward_ios),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    Text(
                      'Your Favorites',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: Responsive.isDesktop(context)
                      ? desktopGridDelegate
                      : mobileGridDelegate,
                  itemCount: _favoriteItems.length,
                  itemBuilder: (context, index) {
                    final Product product = _favoriteItems.toList()[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        context.go(
                          '/product/${product.id}',
                          extra: product.categoryId,
                        );
                        routesProvider.setCurrentRoute(
                          '/product/${product.id}',
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

const SliverGridDelegateWithMaxCrossAxisExtent desktopGridDelegate =
    SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 400,
  crossAxisSpacing: 20,
  mainAxisSpacing: 30,
  mainAxisExtent: 250,
);

const SliverGridDelegateWithFixedCrossAxisCount mobileGridDelegate =
    SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  mainAxisExtent: 270,
);
