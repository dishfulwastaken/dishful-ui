import 'package:dishful/common/data/icons.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/avatar.widget.dart';
import 'package:dishful/pages/recipes/recipes_card.widget.dart';
import 'package:dishful/theme/font.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:parallax_animation/parallax_animation.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final currentIndexProvider = StateProvider((_) => 0);

class RecipesPage extends ConsumerWidget {
  final _controller = PageController();
  late final AsyncValueProvider<List<RecipeMeta?>> recipesProvider;

  RecipesPage() {
    recipesProvider = getAllProvider(DbService.publicDb.recipeMeta());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesValue = ref.watch(recipesProvider);
    final currentIndex = ref.watch(currentIndexProvider);

    final t = recipesValue.toWidget(
      data: (recipes) => recipes.isEmpty
          ? Text('No recipes')
          : ParallaxArea(
              child: MasonryGridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index]!;
                  return ParallaxWidget(
                    overflowHeightFactor: 10,
                    child: RecipesCard(recipe),
                    background: Container(color: Colors.redAccent),
                  );
                },
              ),
            ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Recipes",
          style: TextStyle(
            fontFamily: Fonts.heading,
          ),
        ),
        leading: Avatar(
          onPressed: () => RouteService.goToProfile(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DbService.publicDb.recipeMeta().create(randomRecipeMeta);
        },
        child: const Icon(Icons.plus_one_rounded),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 276,
            child: SalomonBottomBar(
              currentIndex: currentIndex,
              onTap: (index) => ref.set(currentIndexProvider, index),
              selectedItemColor: Palette.primaryDark,
              unselectedItemColor: Palette.primaryLight,
              items: [
                SalomonBottomBarItem(
                  icon: Icon(CustomIcons.iterating_bowl),
                  title: Text(
                    "Iterating",
                    style: TextStyle(fontFamily: Fonts.text),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: Icon(CustomIcons.perfected_bowl),
                  title: Text(
                    "Perfected",
                    style: TextStyle(fontFamily: Fonts.text),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: Icon(CustomIcons.dropped_bowl),
                  title: Text(
                    "Dropped",
                    style: TextStyle(fontFamily: Fonts.text),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) => ref.set(currentIndexProvider, index),
              children: [
                t,
                t,
                t,
              ],
            ),
          )
        ],
      ),
    );
  }
}
