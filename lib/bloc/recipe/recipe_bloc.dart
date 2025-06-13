import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/recipe.dart';
import '../../repositories/recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

/// BLoC для работы с рецептами
class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;

  RecipeBloc(this.repository) : super(RecipeInitial()) {
    on<LoadRecipesEvent>(_onLoadRecipes);
  }

  Future<void> _onLoadRecipes(
    LoadRecipesEvent event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipeList = await repository.fetchRecipes(query: event.query);
      emit(RecipeLoaded(recipeList));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
