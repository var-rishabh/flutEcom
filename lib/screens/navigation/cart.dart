import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flut_mart/models/product.dart';
import 'package:flut_mart/utils/constants/routes.dart';
import 'package:flut_mart/utils/helper/responsive.dart';

import 'package:flut_mart/services/cart.service.dart';
import 'package:flut_mart/widgets/no_data.dart';
import 'package:flut_mart/services/product.service.dart';

import 'package:flut_mart/widgets/icon_button.dart';
import 'package:flut_mart/widgets/snackbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final ProductApiService _productApiService = ProductApiService();
  List<Product> _cartItems = [];
  final Map<String, int> _cartQuantities = {};

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final List<String> cartIds = await _cartService.getCartItems();
    final List<Product> products = await Future.wait(
        cartIds.map((id) => _productApiService.getProductById(id)));
    setState(() {
      _cartItems = products;
    });
    await _loadQuantities();
  }

  Future<void> _loadQuantities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var product in _cartItems) {
        _cartQuantities[product.id.toString()] =
            prefs.getInt(product.id.toString()) ?? 1;
      }
    });
  }

  Future<void> _saveQuantity(String productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(productId, quantity);
  }

  double _calculateTotalAmount() {
    return _cartItems.fold(
        0,
        (sum, item) =>
            sum +
            (item.discountedPrice *
                (_cartQuantities[item.id.toString()] ?? 1)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: Responsive.isDesktop(context)
                ? const EdgeInsets.symmetric(horizontal: 100, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
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
                                    onTap: () {
                                      context.go(KRoutes.home);
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
                          'Your Cart',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total: ',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '\$${_calculateTotalAmount().toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: Responsive.isDesktop(context)
                      ? const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 150,
                        )
                      : const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 140,
                        ),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final Product product = _cartItems[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(
                          '/product/${product.id}',
                          extra: product.categoryId,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 0,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.network(
                              product.image,
                              width: 80,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 10, 10, 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          iconSize: 20,
                                          style: const ButtonStyle(
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          icon:
                                              const Icon(Icons.remove_outlined),
                                          onPressed: () {
                                            setState(
                                              () {
                                                if (_cartQuantities[product.id
                                                        .toString()]! >
                                                    1) {
                                                  _cartQuantities[product.id
                                                          .toString()] =
                                                      _cartQuantities[product.id
                                                              .toString()]! -
                                                          1;
                                                  _saveQuantity(
                                                      product.id.toString(),
                                                      _cartQuantities[product.id
                                                          .toString()]!);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        '${_cartQuantities[product.id.toString()] ?? 1}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.add_outlined),
                                          padding: EdgeInsets.zero,
                                          iconSize: 20,
                                          constraints: const BoxConstraints(),
                                          style: const ButtonStyle(
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: () {
                                            setState(
                                              () {
                                                _cartQuantities[
                                                        product.id.toString()] =
                                                    (_cartQuantities[product.id
                                                                .toString()] ??
                                                            1) +
                                                        1;
                                                _saveQuantity(
                                                  product.id.toString(),
                                                  _cartQuantities[
                                                      product.id.toString()]!,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  transform: Matrix4.rotationZ(0.8),
                                  transformAlignment: Alignment.center,
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    iconSize: 30,
                                    onPressed: () {
                                      setState(
                                        () {
                                          _cartService.removeFromCart(
                                              product.id.toString());
                                          _loadCartItems();
                                        },
                                      );
                                      SharedPreferences.getInstance().then(
                                        (prefs) {
                                          prefs.remove(product.id.toString());
                                        },
                                      );
                                      KSnackBar.show(
                                        context: context,
                                        label: 'Product removed from cart',
                                        type: 'success',
                                        actionLabel: 'Undo',
                                        actionFunction: () {
                                          setState(
                                            () {
                                              _cartService.addToCart(
                                                  product.id.toString());
                                              _loadCartItems();
                                              _saveQuantity(
                                                  product.id.toString(),
                                                  _cartQuantities[
                                                      product.id.toString()]!);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Text(
                                  '\$${product.discountedPrice}',
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
                                const SizedBox(height: 10),
                              ],
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (_cartItems.isEmpty) const NoData(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
