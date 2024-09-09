import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/product.model.dart';

// services
import 'package:flut_mart/services/product.service.dart';

// widgets
import 'package:flut_mart/widgets/app_bar.dart';
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

  int _currentPage = 1;
  bool _isAscending = true;
  int _categoryId = 0;
  bool _isInitialized = false;
  bool _hasMoreProducts = true;

  Future<void> fetchProducts() async {
    final List<Product> products =
        await _productApiService.getProductsByCategoryId(
      _categoryId,
      _currentPage,
      _isAscending ? 0 : 1,
    );
    setState(() {
      _products = products;
      _hasMoreProducts = products.length ==
          20; // If exactly 20 products, assume there might be more
    });
  }

  void _sortProducts() {
    setState(() {
      _isAscending = !_isAscending;
    });
    fetchProducts();
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
    });
    fetchProducts();
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      fetchProducts();
    }
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
                    hintText: 'Type Name...',
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
                          );
                        },
                      );
                    },
                  ),
                  if (_products.isEmpty)
                    const Center(
                      child: Text('No products found'),
                    ),
                  if (_products.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _currentPage > 1
                              ? _loadPreviousPage
                              : null, // Disable if on the first page
                        ),
                        Text(
                          'Page $_currentPage',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: _hasMoreProducts
                              ? _loadNextPage
                              : null, // Disable if no more products
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
