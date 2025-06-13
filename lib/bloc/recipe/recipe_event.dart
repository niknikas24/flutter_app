part of 'recipe_bloc.dart';

/// Абстрактное событие для рецептов
abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

/// Событие загрузки рецептов по ключевому слову
class LoadRecipesEvent extends RecipeEvent {
  final String query;

  const LoadRecipesEvent({this.query = 'chicken'});

  @override
  List<Object> get props => [query];
}
