part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
  
  List<String> get favorites => const [];
  List<Recipe> get recipeList => const [];
}

class FavoriteInitial extends FavoriteState {
  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {
  final String? recipeId;
  const FavoriteLoading({this.recipeId});
  
  @override
  List<Object> get props => [recipeId ?? ''];
}

class FavoriteLoaded extends FavoriteState {
  final List<String> favorites;
  final List<Recipe> recipeList;
  
  const FavoriteLoaded({
    required this.favorites,
    required this.recipeList,
  });

  FavoriteLoaded copyWith({
    List<String>? favorites,
    List<Recipe>? recipeList,
  }) {
    return FavoriteLoaded(
      favorites: favorites ?? this.favorites,
      recipeList: recipeList ?? this.recipeList,
    );
  }

  @override
  List<Object> get props => [favorites, recipeList];
}

class FavoriteError extends FavoriteState {
  final String message;
  
  const FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
