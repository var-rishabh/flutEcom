import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:flut_mart/provider/product.dart';
import 'package:flut_mart/provider/category.dart';
import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/models/category.dart';
import 'package:flut_mart/models/product.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/utils/helper/responsive.dart';

import 'package:flut_mart/widgets/category_card.dart';
import 'package:flut_mart/widgets/recent_product_card.dart';
import 'package:flut_mart/widgets/search_bar.dart';
import 'package:flut_mart/widgets/web_app_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).fetchCategories();
    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).fetchRecentProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final RoutesProvider routesProvider = Provider.of<RoutesProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          if (Responsive.isDesktop(context)) const WebAppBar(),
          Padding(
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isMobile(context))
                  KSearchBar(
                    controller: _searchController,
                    hintText: 'What are you looking for?',
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                if (productProvider.recentProducts.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Viewed',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.recentProducts.length,
                          itemBuilder: (context, index) {
                            final Product product =
                                productProvider.recentProducts[
                                    productProvider.recentProducts.length -
                                        index -
                                        1];
                            return RecentProductCard(
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
                      ),
                      Responsive.isMobile(context)
                          ? const SizedBox(height: 30)
                          : const SizedBox(height: 50),
                    ],
                  ),
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                categoryProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: Responsive.isDesktop(context)
                            ? desktopGridDelegate
                            : mobileGridDelegate,
                        itemCount: searchQuery.isEmpty
                            ? categoryProvider.categories.length
                            : categoryProvider.categories
                                .where((category) => category.name
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()))
                                .length,
                        itemBuilder: (context, index) {
                          final Category category = searchQuery.isEmpty
                              ? categoryProvider.categories[index]
                              : categoryProvider.categories
                                  .where((category) => category.name
                                      .toLowerCase()
                                      .contains(searchQuery.toLowerCase()))
                                  .toList()[index];
                          return CategoryCard(
                            key: Key(category.id.toString()),
                            id: category.id,
                            title: category.name,
                            image: category.image,
                            boxSize: Responsive.isDesktop(context) ? 160 : 100,
                          );
                        },
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const mobileGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
  mainAxisSpacing: 20,
  mainAxisExtent: 130,
);

const desktopGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 200,
  mainAxisSpacing: 80,
  mainAxisExtent: 200,
);
