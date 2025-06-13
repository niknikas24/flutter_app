import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorite/favorite_bloc.dart';
import '../bloc/recipe/recipe_bloc.dart'; 
import '../models/recipe.dart';

// Экран списка рецептов
class RecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список рецептов')),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<RecipeBloc>().add(LoadRecipesEvent()),
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
          return const Center(child: Text('Ошибка загрузки данных'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<RecipeBloc>().add(LoadRecipesEvent()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Function(String) onRemove;

  const RecipeCard({
    required this.recipe,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(recipe.id),
      direction: DismissDirection.endToStart,
      background: Container(color: Colors.red),
      onDismissed: (direction) => onRemove(recipe.id),
      child: ListTile(
        leading: Image.network(
          recipe.imageUrl,
          width: 30,
          height: 30,
          errorBuilder: (_, __, ___) => const Icon(Icons.restaurant_menu),
        ),
        // Используем Row с Expanded, чтобы текст переносился корректно
        title: Row(
          children: [
            Expanded(
              child: Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(
          context,
          '/recipe-detail',
          arguments: recipe,
        ),
      ),
    );
  }
}
