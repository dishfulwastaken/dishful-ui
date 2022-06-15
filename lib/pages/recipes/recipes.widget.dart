import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/dishful_empty.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/common/widgets/dishful_menu.widget.dart';
import 'package:dishful/common/widgets/dishful_modal_bottom_sheet.widget.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:dishful/common/widgets/replacements/form_builder_choice_chips.dart';
import 'package:dishful/pages/recipes/recipes_card.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'
    hide FormBuilderChoiceChip;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parallax_animation/parallax_animation.dart';
import 'package:awesome_extensions/awesome_extensions.dart';

final filterStatusProvider = StateProvider<Status?>((_) => null);

class RecipesPage extends ConsumerWidget {
  late final AsyncValueProvider<List<Recipe>> recipesProvider;

  RecipesPage() {
    recipesProvider = allProvider(
      DbService.publicDb.recipes,
      filters: [
        Filter(
          field: "roles.${AuthService.currentUser.uid}",
          isEqualTo: "owner",
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesValue = ref.watch(recipesProvider);
    final filterStatus = ref.watch(filterStatusProvider);

    final createNewRecipe = () {
      DbService.publicDb.recipes.create(randomRecipe);
      ref.refresh(recipesProvider);
    };

    final recipesList = ParallaxArea(
      child: recipesValue.toWidget(
        data: (recipes) {
          final filteredRecipes = filterStatus == null
              ? recipes
              : recipes
                  .where((recipe) => recipe.status == filterStatus)
                  .toList();

          return filteredRecipes.isEmpty
              ? DishfulEmpty(subject: "recipe", onPressed: createNewRecipe)
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
                          left: isFirst ? 26 : 0,
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
    final filtersList = FormBuilder(
      child: FormBuilderChoiceChip<Status?>(
        name: 'choice_chip',
        onChanged: (status) => ref.set(filterStatusProvider, status),
        pressElevation: 0,
        spacing: 14,
        runSpacing: 10,
        backgroundColor: Colors.white,
        selectedColor: Palette.primary,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.transparent,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        labelPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        labelStyle: context.labelMedium,
        options: [
          FormBuilderFieldOption(value: null, child: Text('All')),
          ...Status.values.map(
            (status) => FormBuilderFieldOption(
              value: status,
              child: Text(status.name.toTitleCase()),
            ),
          )
        ],
      ),
    );
    final modal = DishfulModalBottomSheet(
      title: 'hello there',
      leading: (_, close) => IconButton(
        icon: Icon(Icons.close),
        onPressed: close,
      ),
      body: (_) => Text('kenobi'),
      child: (open) => TextButton(
        child: Text('open me up'),
        onPressed: open,
      ),
    );

    return DishfulScaffold(
      title: "Recipes",
      withDrawer: true,
      leading: (context) => DishfulIconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      action: (_, __) => DishfulMenu(
        items: [
          DishfulMenuItem(
            text: "New Recipe",
            iconData: Icons.add,
            onTap: createNewRecipe,
          ),
          DishfulMenuItem(
            text: "Import",
            iconData: Icons.file_upload,
            onTap: () {},
          ),
        ],
      ),
      body: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          modal,
          filtersList,
          Container(height: 25),
          Expanded(
            child: OverflowBox(child: recipesList, maxWidth: context.width),
          ),
          Container(height: 25),
        ],
      ),
    );
  }
}
