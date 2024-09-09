import 'package:flutter/material.dart';

// models
import 'package:flut_mart/utils/models/product.model.dart';

// services
import 'package:flut_mart/services/cart.service.dart';
import 'package:flut_mart/services/favourite.service.dart';

// widgets
import 'package:flut_mart/widgets/snackbar.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final CartService _cartService = CartService();
  final FavoritesService _favoritesService = FavoritesService();

  bool _isInFavorites = false;
  bool _isInCart = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final List<String> favorites = await _favoritesService.getFavorites();
    final List<String> cart = await _cartService.getCartItems();

    setState(() {
      _isInFavorites = favorites.contains(widget.product.id.toString());
      _isInCart = cart.contains(widget.product.id.toString());
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isInFavorites) {
      await _favoritesService.removeFromFavorites(widget.product.id.toString());
    } else {
      await _favoritesService.addToFavorites(widget.product.id.toString());
    }
    setState(() {
      _isInFavorites = !_isInFavorites;
    });

    if (mounted) {
      KSnackBar.show(
        context: context,
        label: _isInFavorites ? 'Added to Favorites' : 'Removed from Favorites',
        type: "success",
      );
    }
  }

  Future<void> _toggleCart() async {
    if (_isInCart) {
      await _cartService.removeFromCart(widget.product.id.toString());
    } else {
      await _cartService.addToCart(widget.product.id.toString());
    }
    setState(() {
      _isInCart = !_isInCart;
    });
    if (mounted) {
      KSnackBar.show(
        context: context,
        label: _isInCart ? 'Added to Cart' : 'Removed from Cart',
        type: "success",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.asset(
                    widget.product.image,
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                if (widget.product.discount > 0)
                  Positioned(
                    top: 8,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${widget.product.discount}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.product.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${widget.product.discountedPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      '\$${widget.product.price}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 2,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isInCart
                            ? Icons.shopping_cart
                            : Icons.shopping_cart_outlined,
                        color: _isInCart
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade500,
                        size: 30,
                      ),
                      onPressed: _toggleCart,
                    ),
                    IconButton(
                      icon: Icon(
                        _isInFavorites ? Icons.favorite : Icons.favorite_border,
                        color: _isInFavorites
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade500,
                        size: 30,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
