import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/favorite_repository.dart';
import '../../repositories/recipe_repository.dart';
import '../../models/recipe.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

/// BLoC для избранных рецептов
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;
  final RecipeRepository _recipeRepository;

  FavoriteBloc({
    required FavoriteRepository favoriteRepository,
    required RecipeRepository recipeRepository,
  })  : _favoriteRepository = favoriteRepository,
        _recipeRepository = recipeRepository,
        super(FavoriteInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<LoadFavoriteRecipesEvent>(_onLoadFavoriteRecipes);
  }

  Future<void> _onLoadFavoriteRecipes(
    LoadFavoriteRecipesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    if (state is FavoriteLoaded) {
      final currentState = state as FavoriteLoaded;
      try {
        final recipeList =
            await _recipeRepository.fetchRecipesByIds(currentState.favorites);
        emit(currentState.copyWith(recipeList: recipeList));
      } catch (e) {
        emit(FavoriteError(message: 'Ошибка загрузки данных'));
      }
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      emit(FavoriteLoading());
      final favorites = await _favoriteRepository.getFavorites();
      final recipeList = await _recipeRepository.fetchRecipesByIds(favorites);
      emit(FavoriteLoaded(favorites: favorites, recipeList: recipeList));
    } catch (e) {
      emit(FavoriteError(message: 'Ошибка загрузки: ${e.toString()}'));
    }
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      emit(FavoriteLoading(recipeId: event.recipeId));

      final currentFavorites = await _favoriteRepository.getFavorites();
      if (currentFavorites.contains(event.recipeId)) return;

      await _favoriteRepository.addFavorite(event.recipeId);
      final List<String> newFavorites = List.from(currentFavorites)
        ..add(event.recipeId);
      final recipeList = await _recipeRepository.fetchRecipesByIds(newFavorites);

      emit(FavoriteLoaded(favorites: newFavorites, recipeList: recipeList));
    } catch (e) {
      emit(FavoriteError(message: 'Ошибка добавления: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      emit(FavoriteLoading(recipeId: event.recipeId));

      final currentFavorites = await _favoriteRepository.getFavorites();
      if (!currentFavorites.contains(event.recipeId)) return;

      await _favoriteRepository.removeFavorite(event.recipeId);
      final List<String> newFavorites = List.from(currentFavorites)
        ..remove(event.recipeId);
      final List<Recipe> recipeList = newFavorites.isNotEmpty
          ? await _recipeRepository.fetchRecipesByIds(newFavorites)
          : [];

      emit(FavoriteLoaded(favorites: newFavorites, recipeList: recipeList));
    } catch (e) {
      emit(FavoriteError(message: 'Ошибка удаления: ${e.toString()}'));
    }
  }
}
