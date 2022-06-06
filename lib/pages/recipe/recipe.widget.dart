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
    // final recipeValue = ref.watch(recipeProvider);

    final recipeNameProvider = recipeProvider.selectFromData(
      (data) => data?.name,
    );
    final name = Consumer(
      builder: ((context, ref, child) {
        final recipeNameValue = ref.watch(recipeNameProvider);

        return recipeNameValue.toWidget(
          data: (name) => Text(name ?? ''),
          allowError: true,
        );
      }),
    );

    return name;

    // return recipeValue.toWidget(
    //   data: (recipe) {
    //     if (recipe == null) return throw "No recipe found with ID";

    //     final uploadPicture = DishfulUploadPicture(
    //       initialValue:
    //           recipe.pictures.isNotEmpty ? recipe.pictures.first : null,
    //       onUpload: (picture) async {
    //         final updatedRecipe = recipe.copyWith(
    //           pictures: [picture],
    //         );

    //         await DbService.publicDb.recipes.update(updatedRecipe);
    //       },
    //       onDelete: (picture) async {
    //         final updatedRecipe = recipe.copyWith(pictures: []);

    //         await DbService.publicDb.recipes.update(updatedRecipe);
    //       },
    //     );

    //     uploadPicture.build().

    //     return DishfulScaffold(
    //       dynamicTitle: recipeProvider.select((value) => value.value?.name),
    //       dynamicSubtitle: recipeProvider.select(
    //         (value) =>
    //             "${value.value?.iterationCount} Iterations  |  ${value.value?.status.name.toTitleCase()}",
    //       ),
    //       leading: (_) => DishfulIconButton(
    //         icon: const BackButtonIcon(),
    //         onPressed: () {
    //           Navigator.maybePop(context);
    //         },
    //       ),
    //       action: (_, setIsEditing) => DishfulMenu(
    //         items: [
    //           DishfulMenuItem(
    //             text: "New Iteration",
    //             iconData: Icons.add,
    //             onTap: () {
    //               DbService.publicDb
    //                   .iterations(recipe.id)
    //                   .create(randomIteration(recipe.id, recipe.id));
    //             },
    //           ),
    //           DishfulMenuItem(
    //             text: "Edit",
    //             iconData: Icons.edit,
    //             onTap: () {
    //               setIsEditing(true);
    //             },
    //           ),
    //           DishfulMenuItem(
    //             text: "Delete",
    //             iconData: Icons.delete,
    //             onTap: () {
    //               DbService.publicDb.recipes.delete(recipe.id);
    //               Navigator.maybePop(context);
    //             },
    //           ),
    //           DishfulMenuItem(
    //             text: "Export",
    //             iconData: Icons.file_download,
    //             onTap: () {},
    //           ),
    //           DishfulMenuItem(
    //             text: "Sharing",
    //             iconData: Icons.group,
    //             onTap: () {},
    //           ),
    //         ],
    //       ),
    //       onSave: () async {
    //         await uploadPicture.save(ref);
    //         ref.refresh(recipeProvider);
    //       },
    //       body: (isEditing) => Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           if (isEditing)
    //             uploadPicture
    //           else
    //             DishfulPicture(picture: recipe.pictures.maybeFirst),
    //           Expanded(child: Iterations(recipe.id)),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}
