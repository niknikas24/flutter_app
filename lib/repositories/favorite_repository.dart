import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Репозиторий избранных рецептов
class FavoriteRepository {
  static const _favoritesKey = 'favoriteRecipes';

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    if (jsonString == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.cast<String>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      await prefs.setString(_favoritesKey, jsonEncode(favorites));
    }
  }

  Future<void> removeFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(recipeId);
    await prefs.setString(_favoritesKey, jsonEncode(favorites));
  }
}
