import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> addToFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(productId);
    await prefs.setStringList('favorites', favorites);
  }

  Future<void> removeFromFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(productId);
    await prefs.setStringList('favorites', favorites);
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
  }

  Future<bool> isFavorite(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    return favorites.contains(productId);
  }
}
