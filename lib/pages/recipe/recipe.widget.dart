import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/mapWithIndex.dart';
import 'package:dishful/common/data/maybe.dart';
import 'package:dishful/common/data/providers.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';
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
          "${data?.iterationCount} Iterations  |  ${data?.status.name.titleCase}",
      initialValue: initialRecipe,
    );
    final descriptionProvider = recipeProvider.selectFromData(
      (data) => data?.description,
      initialValue: initialRecipe,
    );
    final servesProvider = recipeProvider.selectFromData(
      (data) => data?.serves,
      initialValue: initialRecipe,
    );
    final timeProvider = recipeProvider.selectFromData(
      (data) => data?.totalTime,
      initialValue: initialRecipe,
    );
    final spiceLevelProvider = recipeProvider.selectFromData(
      (data) => data?.spiceLevel,
      initialValue: initialRecipe,
    );
    final dietsProvider = recipeProvider.selectFromData(
      (data) => data?.diets,
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
                        contentPadding: const EdgeInsets.all(2),
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
                  children: instructions.mapWithIndex(
                    (index, instruction) {
                      final number = index + 1;

                      /// [ListTile] is not computing the correct height, so
                      /// we force a dynamic calculation with [IntrinsicHeight].
                      return IntrinsicHeight(
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                          leading: Text("$number:", style: context.labelMedium),
                          title: Text(
                            instruction.title.toString(),
                            style: context.bodyMedium,
                          ),
                          subtitle: instruction.description != null
                              ? Text(
                                  instruction.description!,
                                  style: context.labelMedium,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
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

    final description = Consumer(
      builder: (context, ref, child) {
        final descriptionValue = ref.watch(descriptionProvider);

        return descriptionValue.toWidget(
          data: (_description) => _description == null
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_description),
                    Container(height: 16),
                  ],
                ),
        );
      },
    );

    final serves = Consumer(
      builder: (context, ref, child) {
        final servesValue = ref.watch(servesProvider);

        return servesValue.toWidget(
          data: (_serves) => DishfulIconText(
            text: '$_serves',
            iconData: Icons.group_rounded,
            stretch: false,
          ),
        );
      },
    );

    final time = Consumer(
      builder: (context, ref, child) {
        final timeValue = ref.watch(timeProvider);

        return timeValue.toWidget(
          data: (_time) => DishfulIconText(
            text: '${_time?.inMinutes} min',
            iconData: Icons.timer_rounded,
            stretch: false,
          ),
        );
      },
    );

    final spiceLevel = Consumer(
      builder: (context, ref, child) {
        final spiceLevelValue = ref.watch(spiceLevelProvider);

        return spiceLevelValue.toWidget(
          data: (_spiceLevel) => _spiceLevel == null
              ? Container()
              : DishfulIconText(
                  text: _spiceLevel.name.titleCase,
                  iconData: Icons.local_fire_department_rounded,
                  stretch: false,
                ),
        );
      },
    );

    final diets = Consumer(
      builder: (context, ref, child) {
        final dietsValue = ref.watch(dietsProvider);

        return dietsValue.toWidget(
          data: (_diets) => _diets == null || _diets.isEmpty
              ? Container()
              : DishfulIconText(
                  text: _diets.map((_diet) => _diet.name.titleCase).join(', '),
                  iconData: Icons.eco_rounded,
                  stretch: false,
                ),
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
            iconData: Icons.add_rounded,
            onTap: () async {
              final recipe = ref.read(recipeProvider);

              if (recipe.value != null) {
                await DbService.publicDb
                    .iterations(recipeId)
                    .create(randomIteration(recipe.value!, recipeId));
                ref.refresh(iterationsProvider);
              }
            },
          ),
          DishfulMenuItem(
            text: "Edit",
            iconData: Icons.edit_rounded,
            onTap: () {
              setIsEditing(true);
            },
          ),
          DishfulMenuItem(
            text: "Delete",
            iconData: Icons.delete_rounded,
            onTap: () {
              DbService.publicDb.recipes.delete(recipeId);
              Navigator.maybePop(context);
            },
          ),
          DishfulMenuItem(
            text: "Export",
            iconData: Icons.file_download_rounded,
            onTap: () {},
          ),
          DishfulMenuItem(
            text: "Sharing",
            iconData: Icons.group_rounded,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            iterations,
            Container(height: 12),
            if (isEditing) uploadPicture else picture,
            Container(height: 12),
            Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                serves,
                time,
                spiceLevel,
                diets,
              ],
            ),
            Container(height: 12),
            description,
            IntrinsicHeight(
              child: TabContainer(
                color: Colors.white,
                radius: 6,
                childPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                selectedTextStyle: context.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                unselectedTextStyle: context.bodyMedium,
                tabs: ['Ingredients', 'Instructions'],
                children: [ingredientsTab, instructionsTab],
              ),
            ),
            Container(height: 80),
          ],
        ),
      ),
    );
  }
}
