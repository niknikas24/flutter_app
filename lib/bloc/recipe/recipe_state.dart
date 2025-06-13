part of 'recipe_bloc.dart';

/// Абстрактное состояние для рецептов
abstract class RecipeState extends Equatable {
  final List<Recipe> recipeList;

  const RecipeState({this.recipeList = const []});

  @override
  List<Object> get props => [recipeList];
}

/// Начальное состояние
class RecipeInitial extends RecipeState {}

/// Загрузка рецептов
class RecipeLoading extends RecipeState {}

/// Рецепты успешно загружены
class RecipeLoaded extends RecipeState {
  const RecipeLoaded(List<Recipe> recipeList) : super(recipeList: recipeList);
}

/// Ошибка при загрузке рецептов
class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}
