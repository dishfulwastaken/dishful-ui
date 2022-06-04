import 'package:dishful/common/data/maybe.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/common/widgets/dishful_menu.widget.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:dishful/common/widgets/pictures/dishful_picture.widget.dart';
import 'package:dishful/common/widgets/pictures/dishful_upload_picture.widget.dart';
import 'package:dishful/pages/recipe/recipe_iterations.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipePage extends ConsumerWidget {
  late final AutoDisposeStreamProvider<Recipe?> recipeProvider;

  RecipePage(String id) {
    recipeProvider = watchProvider(DbService.publicDb.recipes, id: id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeValue = ref.watch(recipeProvider);

    ref.listen<String?>(
      /// THIS IS HOW WE DO IT (LISTEN TO PART OF ASYNC VALUE DATA)
      ///
      /// TODO: come up with helper in future provider extension????
      /// TODO: use this everywhere - come up with helper widget so we dont
      /// make our code fucking grosssss
      recipeProvider.select((value) => value.value?.name),
      (previous, next) {
        print("CHANGED----------------------");
      },
    );

    return recipeValue.toWidget(
      data: (recipe) {
        if (recipe == null) return throw "No recipe found with ID";

        final uploadPicture = DishfulUploadPicture(
          initialValue:
              recipe.pictures.isNotEmpty ? recipe.pictures.first : null,
          onUpload: (picture) async {
            final updatedRecipe = recipe.copyWith(
              pictures: [picture],
            );

            await DbService.publicDb.recipes.update(updatedRecipe);
          },
          onDelete: (picture) async {
            final updatedRecipe = recipe.copyWith(pictures: []);

            await DbService.publicDb.recipes.update(updatedRecipe);
          },
        );

        return DishfulScaffold(
          dynamicTitle: recipeProvider.selectValue((value) => value?.name),
          dynamicSubtitle: recipeProvider.selectValue(
            (value) =>
                "${value?.iterationCount} Iterations  |  ${value?.status.name.toTitleCase()}",
          ),
          leading: (_) => DishfulIconButton(
            icon: const BackButtonIcon(),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          action: (_, setIsEditing) => DishfulMenu(
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
                onTap: () {
                  setIsEditing(true);
                },
              ),
              DishfulMenuItem(
                text: "Delete",
                iconData: Icons.delete,
                onTap: () {
                  DbService.publicDb.recipes.delete(recipe.id);
                  Navigator.maybePop(context);
                },
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
          onSave: () async {
            await uploadPicture.save(ref);
            ref.refresh(recipeProvider);
          },
          body: (isEditing) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isEditing)
                uploadPicture
              else
                DishfulPicture(picture: recipe.pictures.maybeFirst),
              Expanded(child: Iterations(recipe.id)),
            ],
          ),
        );
      },
    );
  }
}
