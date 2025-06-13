part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {}

class LoadFavoriteRecipesEvent extends FavoriteEvent {} // Новое событие для загрузки избранных рецептов

class AddFavoriteEvent extends FavoriteEvent {
  final String recipeId;

  const AddFavoriteEvent(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String recipeId;

  const RemoveFavoriteEvent(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}
