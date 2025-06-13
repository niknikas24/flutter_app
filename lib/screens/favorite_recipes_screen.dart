import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';
import 'recipe_screen.dart';

// Экран избранных рецептов
class FavoriteRecipesScreen extends StatelessWidget {
  const FavoriteRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные рецепты'),
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteError) {
            return Center(child: Text(state.message));
          }

          if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('Нет избранных рецептов'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FavoriteBloc>().add(LoadFavoritesEvent());
              },
              child: ListView.builder(
                itemCount: state.recipeList.length,
                itemBuilder: (context, index) => RecipeCard(
                  recipe: state.recipeList[index],
                  onRemove: (id) {
                    context.read<FavoriteBloc>().add(RemoveFavoriteEvent(id));
                  },
                ),
              ),
            );
          }

          return const Center(child: Text('Загрузите избранные рецепты'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<FavoriteBloc>().add(LoadFavoritesEvent()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
