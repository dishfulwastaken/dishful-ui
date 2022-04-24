import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/dishful_bottom_navigation_bar.widget.dart';
import 'package:dishful/common/widgets/editable.widget.dart';
import 'package:dishful/pages/recipe/recipe_iterations.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipePage extends ConsumerWidget {
  late final FutureProvider<Recipe?> recipeProvider;

  RecipePage(String id) {
    recipeProvider = getProvider(DbService.publicDb.recipes, id: id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeValue = ref.watch(recipeProvider);

    return recipeValue.toWidget(
      data: (recipe) {
        if (recipe == null) return Text("No recipe found with ID");

        final title = Stack(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: BackButton(color: Colors.grey.shade400),
              ),
            ),
            Center(
              child: Text(
                recipe.name,
                style: context.headlineSmall,
              ),
            ),
          ],
        );

        return EditableScaffold(
          bottomNavigationBar: DishfulBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.plus_one_rounded),
            onPressed: () async {
              await DbService.publicDb
                  .iterations(recipe.id)
                  .create(randomIteration(recipe.id, recipe.id));
            },
          ),
          body: Column(
            children: [
              Container(height: 35),
              title.paddingSymmetric(horizontal: 34),
              Container(height: 15),
              // Hero(
              //   tag: "recipe-page-${recipe.id}",
              //   child: EditableImage(
              //     initialValue: recipe.image.get,
              //     saveValue: (recipeImage) async {
              //       final updatedRecipe = recipe.copyWithImage(recipeImage);

              //       await DbService.publicDb.recipeMeta().update(updatedRecipe);
              //     },
              //   ),
              // ),
              Text('Your iterations:'),
              Expanded(child: Iterations(recipe.id)),
            ],
          ),
        );
      },
    );
  }
}
