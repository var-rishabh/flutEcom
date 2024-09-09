import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/product.model.dart';

// services
import 'package:flut_mart/services/product.service.dart';

// widgets
import 'package:flut_mart/widgets/app_bar.dart';
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
  List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  bool _isAscending = true;
  int _categoryId = 0;
  bool _isInitialized = false;
  bool _hasMoreProducts = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // Add scroll listener
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
      _isAscending ? 0 : 1,
    );

    setState(() {
      if (_currentPage == 1) {
        _products = products;
      } else {
        _products.addAll(products); // Add new products to the list
      }
      _hasMoreProducts = products.length == 20;
      _isLoading = false;
    });
  }

  void _sortProducts() {
    setState(() {
      _isAscending = !_isAscending;
      _currentPage = 1; // Reset to the first page when sorting changes
    });
    fetchProducts();
  }

  void _scrollListener() {
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
      appBar: KAppBar(
        currentIndex: arguments['currentIndex'],
        onTabSelected: arguments['onTabSelected'],
        needBackButton: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Assign the scroll controller
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KSearchBar(
                    controller: _searchController,
                    hintText: 'Search Product...',
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Products',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
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
                        label: _isAscending
                            ? const Text('Asc')
                            : const Text('Des'),
                        icon: _isAscending
                            ? const Icon(Icons.arrow_downward)
                            : const Icon(Icons.arrow_upward),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 270,
                    ),
                    itemCount: _products.length,
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
                              'onTabSelected': arguments['onTabSelected'],
                            },
                          ).then((_) {
                            setState(() {
                              fetchProducts();
                            });
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
    );
  }
}
