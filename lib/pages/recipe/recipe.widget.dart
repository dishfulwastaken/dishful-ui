import 'package:animations/animations.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/maybe.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_text.widget.dart';
import 'package:dishful/common/widgets/dishful_menu.widget.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:dishful/common/widgets/pictures/dishful_picture.widget.dart';
import 'package:dishful/common/widgets/pictures/dishful_upload_picture.widget.dart';
import 'package:dishful/pages/recipe/recipe_iterations.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tab_container/tab_container.dart';

class RecipePage extends ConsumerWidget {
  late final AsyncValueProvider<Recipe?> recipeProvider;
  late final AsyncValueProvider<List<Iteration>> iterationsProvider;
  late final StateProvider<String?> selectedIterationIdProvider;
  final Recipe? initialRecipe;
  final String recipeId;
  final String? iterationId;
  final uploadPictureController = new DishfulUploadPictureController();

  RecipePage(this.recipeId, {this.initialRecipe, this.iterationId}) {
    recipeProvider = oneProvider(DbService.publicDb.recipes, id: recipeId);
    iterationsProvider = allProvider(DbService.publicDb.iterations(recipeId));
    selectedIterationIdProvider = StateProvider((_) => iterationId);
  }

  Widget buildIconTextButton({
    required String text,
    required IconData iconData,
    required void Function() onPressed,
  }) =>
      TextButton(
        onPressed: onPressed,
        child: DishfulIconText(
          text: text,
          iconData: iconData,
          stretch: false,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIterationId = ref.watch(selectedIterationIdProvider);
    final iterationProvider = iterationsProvider.selectFromData(
      (data) => data.maybeSingleWhere(
        (iteration) => iteration.id == selectedIterationId,
      ),
    );
    final iterationValue = ref.watch(iterationProvider);

    final iterations = Iterations(
      recipeId,
      initialRecipe,
      iterationValue,
      iterationsProvider: iterationsProvider,
      selectedIterationIdProvider: selectedIterationIdProvider,
    );

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
    final instructionsProvider = recipeProvider.selectFromData(
      (data) => data?.instructions,
      initialValue: initialRecipe,
    );
    final ingredientsProvider = recipeProvider.selectFromData(
      (data) => data?.ingredients,
      initialValue: initialRecipe,
    );

    final ingredientsTab = Consumer(
      builder: (context, ref, child) {
        final ingredientsValue = ref.watch(ingredientsProvider);

        return ingredientsValue.toWidget(
          data: (ingredients) => ingredients!.isEmpty
              ? Text('No ingredients').paddingAll(20)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ingredients.map((ingredient) {
                    /// [ListTile] is not computing the correct height, so
                    /// we force a dynamic calculation with [IntrinsicHeight].
                    return IntrinsicHeight(
                      child: ListTile(
                        // leading: Text("$number:", style: context.labelMedium),
                        title: Text(
                          ingredient.toString(),
                          style: context.bodyMedium,
                        ),
                        subtitle: ingredient.substitutes.isNotEmpty
                            ? Text(
                                "${ingredient.substitutes.length} substitute(s) available",
                                style: context.labelMedium,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
    final instructionsTab = Consumer(
      builder: (context, ref, child) {
        final instructionsValue = ref.watch(instructionsProvider);

        return instructionsValue.toWidget(
          data: (instructions) => instructions!.isEmpty
              ? Text('No instructions').paddingAll(20)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: instructions
                      .asMap()
                      .map((index, instruction) => MapEntry(index,
                          Text("${index + 1}) ${instruction.description}")))
                      .values
                      .toList(),
                ),
        );
      },
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
      body: (isEditing) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iterations,
            Container(height: 12),
            if (isEditing) uploadPicture else picture,
            Container(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildIconTextButton(
                  text: '4',
                  iconData: Icons.group,
                  onPressed: () {},
                ),
                buildIconTextButton(
                  text: '25 min',
                  iconData: Icons.timer,
                  onPressed: () {},
                ),
                buildIconTextButton(
                  text: '2.8',
                  iconData: Icons.star,
                  onPressed: () {},
                ),
              ],
            ),
            Container(height: 12),
            IntrinsicHeight(
              child: TabContainer(
                color: Colors.white,
                radius: 6,
                childPadding: const EdgeInsets.all(12.0),
                selectedTextStyle: context.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                unselectedTextStyle: context.bodyMedium,
                tabs: ['Ingredients', 'Instructions'],
                children: [ingredientsTab, instructionsTab],
              ),
            ),
            Container(height: 800),
          ],
        ),
      ),
    );
  }
}
