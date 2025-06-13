import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

/// Можно перенести в глобальный constants.dart или оставить здесь
const List<String> defaultQueryTerms = [
  'chicken',
  'pasta',
  'beef',
  'soup',
  'dessert',
  'salad',
  'seafood',
  'vegetarian',
  'breakfast',
  'lamb',
  'pork',
  'vegan',
  'goat',
  'turkey'
];

/// Репозиторий для загрузки рецептов
class RecipeRepository {
  static const _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Получает рецепты по поисковому запросу
  Future<List<Recipe>> fetchRecipes({String query = 'chicken'}) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'];
      if (data == null) return [];

      return data.map<Recipe>((json) => Recipe.fromJson(json)).toList();
    }

    throw Exception('Ошибка при загрузке рецептов');
  }

  /// Получает рецепты по списку ID
  Future<List<Recipe>> fetchRecipesByIds(List<String> ids) async {
    List<Recipe> recipes = [];

    for (final id in ids) {
      final response =
          await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['meals'];
        if (data != null && data.isNotEmpty) {
          recipes.add(Recipe.fromJson(data[0]));
        }
      } else {
        throw Exception('Ошибка при загрузке рецепта с ID: $id');
      }
    }

    return recipes;
  }
}
