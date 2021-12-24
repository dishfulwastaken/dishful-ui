import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/pages/recipes/recipes_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Recipes extends ConsumerWidget {
  final recipesProvider = getAllProvider(localDb.recipe);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      body: Column(
        children: [
          const Text('Recipes!'),
          FloatingActionButton(onPressed: () async {
            await localDb.recipe.create(Recipe(
              id: "12",
              name: "logan",
              description: "yummy",
              inspiration: "a dream",
              serves: 3,
              spiceLevel: 5,
              diets: null,
              cookTime: Duration.zero,
              prepTime: Duration(hours: 1),
              status: RecipeStatus.iterating,
              iterationIds: [],
              ingredientIds: [],
              stepIds: [],
              reviewId: "",
            ));
          }),
          recipesAsync.when(
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text('$error\n$stack'),
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
              })
        ],
      ),
    );
  }
}
