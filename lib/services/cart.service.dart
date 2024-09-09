import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  Future<List<String>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('cart') ?? [];
  }

  Future<void> addToCart(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cart = prefs.getStringList('cart') ?? [];
    cart.add(productId);
    await prefs.setStringList('cart', cart);
  }

  Future<void> removeFromCart(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cart = prefs.getStringList('cart') ?? [];
    cart.remove(productId);
    await prefs.setStringList('cart', cart);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
  }
}
