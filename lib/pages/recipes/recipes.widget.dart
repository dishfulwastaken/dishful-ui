import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/async_loading.widget.dart';
import 'package:dishful/pages/recipes/recipes_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishful/common/widgets/async_error.widget.dart';

class RecipesPage extends ConsumerWidget {
  late final AutoDisposeStreamProvider<List<Recipe?>> recipesProvider;

  RecipesPage() {
    recipesProvider = getAllProvider(localDb.recipe);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);

    return recipesAsync.when(
        loading: asyncLoading,
        error: asyncError,
        data: (recipes) {
          final noRecipes = recipes.first == null;
          return noRecipes
              ? Text('No recipes')
              : Scaffold(
                  appBar: AppBar(title: const Text('Recipes')),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      await localDb.recipe.create(randomRecipe);
                    },
                    child: const Icon(Icons.plus_one_rounded),
                  ),
                  body: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index]!;
                      return RecipesCard(recipe);
                    },
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  ),
                );
        });
  }
}
