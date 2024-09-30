import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flut_mart/provider/routes.dart';
import 'package:flut_mart/provider/product.dart';
import 'package:flut_mart/provider/category.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/utils/helper/responsive.dart';
import 'package:flut_mart/models/product.dart';

import 'package:flut_mart/widgets/app_bar.dart';
import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/no_data.dart';
import 'package:flut_mart/widgets/product_card.dart';
import 'package:flut_mart/widgets/search_bar.dart';

class ProductsScreen extends StatefulWidget {
  final int categoryId;

  const ProductsScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final ScrollController _scrollController = ScrollController();

  int _categoryId = 0;

  int _currentPage = 1;
  bool _isAscending = true;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _categoryId = widget.categoryId;
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    await categoryProvider.fetchCategoryById(_categoryId);
    await productProvider.fetchProductByCategory(
      _categoryId,
      _currentPage,
      _isAscending ? 2 : 3,
    );
  }

  void _sortProducts() {
    setState(() {
      _isAscending = !_isAscending;
      _currentPage = 1;
    });
    fetchProducts();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels > 300) {
      setState(() {
        _showScrollToTop = true;
      });
    } else {
      setState(() {
        _showScrollToTop = false;
      });
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        Provider.of<ProductProvider>(context, listen: false).hasMoreProducts &&
        !Provider.of<ProductProvider>(context, listen: false).isLoading) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
    });
    fetchProducts();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context);
    final RoutesProvider routesProvider = Provider.of<RoutesProvider>(context);

    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? null
          : const KAppBar(
              needBackButton: true,
            ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: Responsive.isDesktop(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 10,
                          )
                        : const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Responsive.isDesktop(context)
                                ? Row(
                                    children: [
                                      KIconButton(
                                        icon: Icons.home,
                                        isActive: false,
                                        onTap: () => {
                                          context.go(KRoutes.home),
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
                              categoryProvider.category.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Responsive.isDesktop(context)
                            ? Expanded(
                                child: KSearchBar(
                                  controller: _searchController,
                                  hintText: 'Search Product...',
                                  onChanged: (query) {
                                    setState(() {
                                      searchQuery = query;
                                    });
                                  },
                                ),
                              )
                            : const SizedBox(),
                        Responsive.isDesktop(context)
                            ? const SizedBox(width: 20)
                            : const SizedBox(),
                        ElevatedButton.icon(
                          onPressed: _sortProducts,
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.secondary,
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          label: const Text('Price'),
                          icon: _isAscending
                              ? const Icon(Icons.arrow_downward)
                              : const Icon(Icons.arrow_upward),
                        ),
                      ],
                    ),
                  ),
                  !Responsive.isDesktop(context)
                      ? const SizedBox(height: 20)
                      : const SizedBox(height: 0),
                  GridView.builder(
                    shrinkWrap: true,
                    padding: Responsive.isDesktop(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 10,
                          )
                        : const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: Responsive.isDesktop(context)
                        ? desktopGridDelegate
                        : mobileGridDelegate,
                    itemCount: searchQuery.isEmpty
                        ? productProvider.products.length
                        : productProvider.products
                            .where((product) => product.name
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                            .length,
                    itemBuilder: (context, index) {
                      final Product product = searchQuery.isEmpty
                          ? productProvider.products[index]
                          : productProvider.products
                              .where((product) => product.name
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()))
                              .toList()[index];
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
                  if (productProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (!productProvider.isLoading &&
                      productProvider.products.isEmpty)
                    const NoData(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
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
