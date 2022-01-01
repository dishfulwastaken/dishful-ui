import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/async_loading.widget.dart';
import 'package:dishful/pages/recipes/recipes_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishful/common/widgets/async_error.widget.dart';

class RecipesPage extends ConsumerWidget {
  late final AutoDisposeStreamProvider<List<RecipeMeta?>> recipesProvider;

  RecipesPage() {
    recipesProvider = getAllProvider(DbService.privateDb.recipeMeta);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DbService.privateDb.recipeMeta.create(randomRecipeMeta);
        },
        child: const Icon(Icons.plus_one_rounded),
      ),
      body: recipesAsync.when(
        loading: asyncLoading,
        error: asyncError,
        data: (recipes) {
          final noRecipes = recipes.first == null;
          return noRecipes
              ? Text('No recipes')
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index]!;
                    return RecipesCard(recipe);
                  },
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                );
        },
      ),
    );
  }
}
