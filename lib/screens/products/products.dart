import 'package:flutter/material.dart';

import 'package:flut_mart/utils/helper/responsive.dart';
import 'package:flut_mart/models/product.dart';
import 'package:flut_mart/services/product.service.dart';

import 'package:flut_mart/widgets/app_bar.dart';
import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/no_data.dart';
import 'package:flut_mart/widgets/product_card.dart';
import 'package:flut_mart/widgets/search_bar.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '/products';

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final ProductApiService _productApiService = ProductApiService();
  final ScrollController _scrollController = ScrollController();
  List<Product> _products = [];

  int _currentPage = 1;
  bool _isAscending = true;
  int _categoryId = 0;
  bool _isInitialized = false;
  bool _hasMoreProducts = true;
  bool _isLoading = false;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final List<Product> products =
        await _productApiService.getProductsByCategoryId(
      _categoryId,
      _currentPage,
      _isAscending ? 2 : 3,
    );

    setState(() {
      if (_currentPage == 1) {
        _products = products;
      } else {
        _products.addAll(products);
      }
      _hasMoreProducts = products.length == 20;
      _isLoading = false;
    });
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
        _hasMoreProducts &&
        !_isLoading) {
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, dynamic>{}) as Map;
      setState(() {
        _categoryId = arguments['categoryId'] ?? 0;
      });

      fetchProducts();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? null
          : KAppBar(
              currentIndex: arguments['currentIndex'],
              onTabSelected: arguments['onTabSelected'],
              needBackButton: true,
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _currentPage = 1;
          });
          await fetchProducts();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                            Navigator.pushNamed(
                                              context,
                                              '/app',
                                              arguments: {
                                                'currentIndex': 0,
                                                'onTabSelected':
                                                    arguments['onTabSelected'],
                                              },
                                            )
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
                                'Products',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                    Responsive.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 10,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 30,
                                mainAxisExtent: 250,
                              ),
                              itemCount: searchQuery.isEmpty
                                  ? _products.length
                                  : _products
                                      .where((product) => product.name
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase()))
                                      .length,
                              itemBuilder: (context, index) {
                                final Product product = searchQuery.isEmpty
                                    ? _products[index]
                                    : _products
                                        .where((product) => product.name
                                            .toLowerCase()
                                            .contains(
                                                searchQuery.toLowerCase()))
                                        .toList()[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/product-details',
                                      arguments: {
                                        'productId': product.id,
                                        'currentIndex':
                                            arguments['currentIndex'],
                                        'onTabSelected':
                                            arguments['onTabSelected'],
                                      },
                                    ).then((value) {
                                      if (value != null && value == true) {
                                        setState(() {
                                          _currentPage = 1;
                                          _isInitialized = false;
                                        });
                                        fetchProducts();
                                      }
                                    });
                                  },
                                );
                              },
                            ),
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
                            itemCount: searchQuery.isEmpty
                                ? _products.length
                                : _products
                                    .where((product) => product.name
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase()))
                                    .length,
                            itemBuilder: (context, index) {
                              final Product product = searchQuery.isEmpty
                                  ? _products[index]
                                  : _products
                                      .where((product) => product.name
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase()))
                                      .toList()[index];
                              return ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product-details',
                                    arguments: {
                                      'productId': product.id,
                                      'currentIndex': arguments['currentIndex'],
                                      'onTabSelected':
                                          arguments['onTabSelected'],
                                    },
                                  ).then((value) {
                                    if (value != null && value == true) {
                                      setState(() {
                                        _currentPage = 1;
                                        _isInitialized = false;
                                      });
                                      fetchProducts();
                                    }
                                  });
                                },
                              );
                            },
                          ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (!_isLoading && _products.isEmpty) const NoData(),
                  ],
                ),
              ),
            ],
          ),
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
