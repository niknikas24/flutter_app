import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

/// Модель рецепта блюда
@JsonSerializable()
class Recipe {
  @JsonKey(name: 'idMeal')
  final String id;

  @JsonKey(name: 'strMeal')
  final String name;

  @JsonKey(name: 'strCategory')
  final String category;

  @JsonKey(name: 'strArea')
  final String area;

  @JsonKey(name: 'strMealThumb')
  final String imageUrl;

  @JsonKey(name: 'strInstructions')
  final String instructions;

  @JsonKey(name: 'strYoutube')
  final String? youtubeUrl;

  // Добавим поля ингредиентов и мер (опционально)
  @JsonKey(name: 'strIngredient1')
  final String? ingredient1;

  @JsonKey(name: 'strIngredient2')
  final String? ingredient2;

  @JsonKey(name: 'strIngredient3')
  final String? ingredient3;

  @JsonKey(name: 'strIngredient4')
  final String? ingredient4;

  @JsonKey(name: 'strIngredient5')
  final String? ingredient5;

  @JsonKey(name: 'strIngredient6')
  final String? ingredient6;

  @JsonKey(name: 'strIngredient7')
  final String? ingredient7;

  @JsonKey(name: 'strIngredient8')
  final String? ingredient8;

  @JsonKey(name: 'strIngredient9')
  final String? ingredient9;

  @JsonKey(name: 'strIngredient10')
  final String? ingredient10;

  @JsonKey(name: 'strIngredient11')
  final String? ingredient11;

  @JsonKey(name: 'strIngredient12')
  final String? ingredient12;

  @JsonKey(name: 'strIngredient13')
  final String? ingredient13;

  @JsonKey(name: 'strIngredient14')
  final String? ingredient14;

  @JsonKey(name: 'strIngredient15')
  final String? ingredient15;

  @JsonKey(name: 'strIngredient16')
  final String? ingredient16;

  @JsonKey(name: 'strIngredient17')
  final String? ingredient17;

  @JsonKey(name: 'strIngredient18')
  final String? ingredient18;

  @JsonKey(name: 'strIngredient19')
  final String? ingredient19;

  @JsonKey(name: 'strIngredient20')
  final String? ingredient20;

  @JsonKey(name: 'strMeasure1')
  final String? measure1;

  @JsonKey(name: 'strMeasure2')
  final String? measure2;

  @JsonKey(name: 'strMeasure3')
  final String? measure3;

  @JsonKey(name: 'strMeasure4')
  final String? measure4;

  @JsonKey(name: 'strMeasure5')
  final String? measure5;

  @JsonKey(name: 'strMeasure6')
  final String? measure6;

  @JsonKey(name: 'strMeasure7')
  final String? measure7;

  @JsonKey(name: 'strMeasure8')
  final String? measure8;

  @JsonKey(name: 'strMeasure9')
  final String? measure9;

  @JsonKey(name: 'strMeasure10')
  final String? measure10;

  @JsonKey(name: 'strMeasure11')
  final String? measure11;

  @JsonKey(name: 'strMeasure12')
  final String? measure12;

  @JsonKey(name: 'strMeasure13')
  final String? measure13;

  @JsonKey(name: 'strMeasure14')
  final String? measure14;

  @JsonKey(name: 'strMeasure15')
  final String? measure15;

  @JsonKey(name: 'strMeasure16')
  final String? measure16;

  @JsonKey(name: 'strMeasure17')
  final String? measure17;

  @JsonKey(name: 'strMeasure18')
  final String? measure18;

  @JsonKey(name: 'strMeasure19')
  final String? measure19;

  @JsonKey(name: 'strMeasure20')
  final String? measure20;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.instructions,
    this.youtubeUrl,
    this.ingredient1,
    this.ingredient2,
    this.ingredient3,
    this.ingredient4,
    this.ingredient5,
    this.ingredient6,
    this.ingredient7,
    this.ingredient8,
    this.ingredient9,
    this.ingredient10,
    this.ingredient11,
    this.ingredient12,
    this.ingredient13,
    this.ingredient14,
    this.ingredient15,
    this.ingredient16,
    this.ingredient17,
    this.ingredient18,
    this.ingredient19,
    this.ingredient20,
    this.measure1,
    this.measure2,
    this.measure3,
    this.measure4,
    this.measure5,
    this.measure6,
    this.measure7,
    this.measure8,
    this.measure9,
    this.measure10,
    this.measure11,
    this.measure12,
    this.measure13,
    this.measure14,
    this.measure15,
    this.measure16,
    this.measure17,
    this.measure18,
    this.measure19,
    this.measure20,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

/// Геттеры совместимости и вспомогательные методы
extension RecipeCompat on Recipe {
  String get title => name;

  String get description => instructions;

  String get symbol => id;

  /// Собирает список ингредиентов с мерами
  List<String> get ingredients {
    final List<String?> ingredientFields = [
      ingredient1,
      ingredient2,
      ingredient3,
      ingredient4,
      ingredient5,
      ingredient6,
      ingredient7,
      ingredient8,
      ingredient9,
      ingredient10,
      ingredient11,
      ingredient12,
      ingredient13,
      ingredient14,
      ingredient15,
      ingredient16,
      ingredient17,
      ingredient18,
      ingredient19,
      ingredient20,
    ];

    final List<String?> measureFields = [
      measure1,
      measure2,
      measure3,
      measure4,
      measure5,
      measure6,
      measure7,
      measure8,
      measure9,
      measure10,
      measure11,
      measure12,
      measure13,
      measure14,
      measure15,
      measure16,
      measure17,
      measure18,
      measure19,
      measure20,
    ];

    List<String> result = [];
    for (int i = 0; i < ingredientFields.length; i++) {
      final ingredient = ingredientFields[i]?.trim();
      final measure = measureFields[i]?.trim();

      if (ingredient != null && ingredient.isNotEmpty) {
        if (measure != null && measure.isNotEmpty) {
          result.add('$ingredient - $measure');
        } else {
          result.add(ingredient);
        }
      }
    }
    return result;
  }
}
