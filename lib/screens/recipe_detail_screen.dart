import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';

// Экран детальной карточки рецепта
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
              recipe.imageUrl,
              width: 30,
              height: 30,
              errorBuilder: (_, __, ___) => const Icon(Icons.restaurant_menu),
            ),
            const SizedBox(width: 12),
            Expanded( // Ограничиваем ширину текста и даем перенос
              child: Text(
                recipe.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Добавляем прокрутку
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  recipe.imageUrl,
                  width: 120,
                  height: 120,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.restaurant_menu,
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildFavoriteButton(context),
              const SizedBox(height: 30),
              Text(
                'Ингредиенты',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                recipe.ingredients.join(', '),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              Text(
                'Описание',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                recipe.instructions,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Назад к списку'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return BlocConsumer<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isProcessing = state is FavoriteLoading &&
            (state.recipeId == recipe.id || state.recipeId == null);

        if (isProcessing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final isFavorite = state.favorites.contains(recipe.id);
        return Center(
          child: FloatingActionButton.extended(
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
            label: Text(
              isFavorite ? 'В избранном' : 'Добавить в избранное',
              style: TextStyle(
                color: isFavorite ? Colors.amber : Colors.blueGrey,
              ),
            ),
            onPressed: () {
              context.read<FavoriteBloc>().add(
                    isFavorite
                        ? RemoveFavoriteEvent(recipe.id)
                        : AddFavoriteEvent(recipe.id),
                  );
            },
            backgroundColor: Colors.white,
            elevation: 4,
          ),
        );
      },
    );
  }
}
