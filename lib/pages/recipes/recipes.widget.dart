import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/dishful_bottom_navigation_bar.widget.dart';
import 'package:dishful/common/widgets/editable.widget.dart';
import 'package:dishful/common/widgets/replacements/form_builder_choice_chips.dart';
import 'package:dishful/pages/recipes/recipes_card.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'
    hide FormBuilderChoiceChip;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallax_animation/parallax_animation.dart';
import 'package:awesome_extensions/awesome_extensions.dart';

final filterStatusProvider = StateProvider<RecipeStatus?>((_) => null);

class RecipesPage extends ConsumerWidget {
  late final AsyncValueProvider<List<Recipe>> recipesProvider;

  RecipesPage() {
    recipesProvider = getAllProvider(DbService.publicDb.recipes);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesValue = ref.watch(recipesProvider);
    final filterStatus = ref.watch(filterStatusProvider);

    final title = Align(
      alignment: Alignment.topLeft,
      child: Text(
        "Let's make some\ndishes!",
        style: context.headlineMedium,
      ),
    );
    final recipesList = ParallaxArea(
      child: recipesValue.toWidget(
        data: (recipes) {
          final filteredRecipes = filterStatus == null
              ? recipes
              : recipes
                  .where((recipe) => recipe.status == filterStatus)
                  .toList();

          return filteredRecipes.isEmpty
              ? Text("No recipes")
              : Flexible(
                  child: AnimatedSwitcher(
                    duration: 400.milliseconds,
                    child: ListView.builder(
                      key: ValueKey(filteredRecipes.length),
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final isFirst = index == 0;
                        final recipe = filteredRecipes[index];
                        return RecipesCard(recipe).paddingOnly(
                          right: 16,
                          left: isFirst ? context.width * 0.10 : 0,
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
    final filtersList = FormBuilder(
      child: FormBuilderChoiceChip<RecipeStatus?>(
        name: 'choice_chip',
        onChanged: (status) => ref.set(filterStatusProvider, status),
        pressElevation: 0,
        spacing: 14,
        runSpacing: 10,
        backgroundColor: Colors.white,
        selectedColor: Palette.primary,
        decoration: InputDecoration(border: InputBorder.none),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        labelStyle: TextStyle(
          color: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return Colors.black;
            if (states.contains(MaterialState.selected)) return Colors.white;
            return Colors.grey.shade400;
          }),
        ),
        options: [
          FormBuilderFieldOption(value: null, child: Text('All')),
          ...RecipeStatus.values.map(
            (status) => FormBuilderFieldOption(
              value: status,
              child: Text(status.name.toTitleCase()),
            ),
          )
        ],
      ),
    );

    return EditableScaffold(
      bottomNavigationBar: DishfulBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one_rounded),
        onPressed: () async {
          await DbService.publicDb.recipes.create(randomRecipe);
        },
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 35),
          title.paddingOnly(left: 34),
          Container(height: 15),
          filtersList.paddingSymmetric(horizontal: 34),
          Container(height: 25),
          recipesList,
          Container(height: 25),
        ],
      ),
    );
  }
}
