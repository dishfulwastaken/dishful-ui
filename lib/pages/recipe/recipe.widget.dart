import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/common/widgets/dishful_menu.widget.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:dishful/common/widgets/editable.widget.dart';
import 'package:dishful/pages/recipe/recipe_iterations.widget.dart';
import 'package:dishful/theme/palette.dart';
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
        if (recipe == null) return throw "No recipe found with ID";

        return DishfulScaffold(
          title: recipe.name,
          subtitle:
              "${recipe.iterationCount} Iterations  |  ${recipe.status.name.toTitleCase()}",
          leading: DishfulIconButton(
            icon: const BackButtonIcon(),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          action: DishfulMenu(
            items: [
              DishfulMenuItem(
                text: "New Iteration",
                iconData: Icons.add,
                onTap: () {
                  DbService.publicDb
                      .iterations(recipe.id)
                      .create(randomIteration(recipe.id, recipe.id));
                },
              ),
              DishfulMenuItem(
                text: "Edit",
                iconData: Icons.edit,
                onTap: () {},
              ),
              DishfulMenuItem(
                text: "Delete",
                iconData: Icons.delete,
                onTap: () {},
              ),
              DishfulMenuItem(
                text: "Export",
                iconData: Icons.file_download,
                onTap: () {},
              ),
              DishfulMenuItem(
                text: "Sharing",
                iconData: Icons.group,
                onTap: () {},
              ),
            ],
          ),
          body: Iterations(recipe.id),
        );

        // return EditableScaffold(
        //   floatingActionButton: FloatingActionButton(
        //     child: const Icon(Icons.plus_one_rounded),
        //     onPressed: () async {
        //       await DbService.publicDb
        //           .iterations(recipe.id)
        //           .create(randomIteration(recipe.id, recipe.id));
        //     },
        //   ),
        //   body: Column(
        //     children: [
        //       Container(height: 35),
        //       title.paddingSymmetric(horizontal: 34),
        //       Container(height: 15),
        //       // Hero(
        //       //   tag: "recipe-page-${recipe.id}",
        //       //   child: EditableImage(
        //       //     initialValue: recipe.image.get,
        //       //     saveValue: (recipeImage) async {
        //       //       final updatedRecipe = recipe.copyWithImage(recipeImage);

        //       //       await DbService.publicDb.recipeMeta().update(updatedRecipe);
        //       //     },
        //       //   ),
        //       // ),
        //       Text('Your iterations:'),
        //       Expanded(child: Iterations(recipe.id)),
        //     ],
        //   ),
        // );
      },
    );
  }
}
