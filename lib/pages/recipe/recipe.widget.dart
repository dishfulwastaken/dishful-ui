import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/pages/recipe/recipe_iterations.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipePage extends ConsumerWidget {
  late final AsyncValueProvider<RecipeMeta> recipeProvider;

  RecipePage(String id) {
    recipeProvider = getProvider(DbService.publicDb.recipeMeta(), id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeValue = ref.watch(recipeProvider);

    return recipeValue.toWidget(
      data: (recipe) {
        return Scaffold(
          appBar: AppBar(title: Text(recipe.name)),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await DbService.publicDb
                  .recipeIteration(recipe.id)
                  .create(randomRecipeIteration(recipe.id));
            },
            child: const Icon(Icons.plus_one_rounded),
          ),
          body: Column(
            children: [
              Text('Your iterations:'),
              RecipeIterations(recipe.id),
            ],
          ),
        );
      },
    );
  }
}
