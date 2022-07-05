import 'package:animations/animations.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/maybe.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
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
  late final AsyncValueProvider<Recipe?> recipeProvider;
  final Recipe? initialRecipe;
  final String recipeId;
  final String? iterationId;
  final uploadPictureController = new DishfulUploadPictureController();

  RecipePage(this.recipeId, {this.initialRecipe, this.iterationId}) {
    recipeProvider = oneProvider(DbService.publicDb.recipes, id: recipeId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleProvider = recipeProvider.selectFromData(
      (data) => data?.name,
      initialValue: initialRecipe,
    );
    final subtitleProvider = recipeProvider.selectFromData(
      (data) =>
          "${data?.iterationCount} Iterations  |  ${data?.status.name.toTitleCase()}",
      initialValue: initialRecipe,
    );
    final picturesProvider = recipeProvider.selectFromData(
      (data) => data?.pictures,
      initialValue: initialRecipe,
    );

    final iterationsDropdown = OpenContainer(
      closedElevation: 0,
      closedBuilder: (context, open) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fork_right),
            Container(width: 8),
            Text(iterationId ?? 'Iteration 1', style: context.bodySmall),
            Spacer(),
            Icon(Icons.expand_more),
          ],
        ),
      ),
      openBuilder: (context, close) => DishfulScaffold(
        title: iterationId ?? 'Iteration 1',
        subtitle: 'yeety 2',
        leading: (_) => DishfulIconButton(
          icon: Icon(Icons.close),
          onPressed: close,
        ),
        body: (_) => Text('yeet body'),
      ),
    );

    final uploadPicture = Consumer(
      builder: (context, ref, child) {
        final picturesValue = ref.watch(picturesProvider);

        return picturesValue.toWidget(
          data: (pictures) => DishfulUploadPicture(
            controller: uploadPictureController,
            initialValue:
                pictures != null && pictures.isNotEmpty ? pictures.first : null,
            onUpload: (picture) async {
              final recipe = ref.read(recipeProvider).asData!.value!;
              final updatedRecipe = recipe.copyWith(
                pictures: [picture],
              );

              await DbService.publicDb.recipes.update(updatedRecipe);
            },
            onDelete: (picture) async {
              final recipe = ref.read(recipeProvider).asData!.value!;
              final updatedRecipe = recipe.copyWith(pictures: []);

              await DbService.publicDb.recipes.update(updatedRecipe);
            },
          ),
        );
      },
    );

    final picture = Consumer(
      builder: (context, ref, child) {
        final picturesValue = ref.watch(picturesProvider);

        return picturesValue.toWidget(
          data: (pictures) => DishfulPicture(picture: pictures?.maybeFirst),
        );
      },
    );

    return DishfulScaffold(
      titleProvider: titleProvider,
      subtitleProvider: subtitleProvider,
      leading: (_) => DishfulIconButton(
        icon: const BackButtonIcon(),
        onPressed: () {
          RouteService.goRecipes();
        },
      ),
      action: (_, setIsEditing) => DishfulMenu(
        items: [
          DishfulMenuItem(
            text: "New Iteration",
            iconData: Icons.add,
            onTap: () {
              DbService.publicDb
                  .iterations(recipeId)
                  .create(randomIteration(recipeId, recipeId));
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
              DbService.publicDb.recipes.delete(recipeId);
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
        await uploadPictureController.save();
        ref.refresh(recipeProvider);
      },
      body: (isEditing) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iterationsDropdown,
          if (isEditing) uploadPicture else picture,
          Expanded(child: Iterations(recipeId)),
        ],
      ),
    );
  }
}
