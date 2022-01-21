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
  late final AsyncValueProvider<List<RecipeMeta>> recipesProvider;

  RecipesPage() {
    recipesProvider = getAllProvider(DbService.publicDb.recipeMeta());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesValue = ref.watch(recipesProvider);
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DbService.publicDb.recipeMeta().create(randomRecipeMeta);
        },
        child: const Icon(Icons.plus_one_rounded),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            title: Align(
              alignment: Alignment.center,
              child: Text(
                "Recipes",
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: Fonts.headline,
                  color: Colors.black54,
                ),
              ),
            ),
            actions: [Container(width: 38)],
            leadingWidth: 38,
            leading: Avatar(
              onPressed: () => RouteService.goToProfile(context),
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            floating: true,
            pinned: true,
            snap: false,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                width: 276,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: StadiumBorder(),
                ),
                child: SalomonBottomBar(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    ref.set(currentIndexProvider, index);
                    _controller.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
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
            ),
          )
        ],
        body: PageView(
          controller: _controller,
          onPageChanged: (index) => ref.set(currentIndexProvider, index),
          children: RecipeStatus.values
              .map(
                (status) => recipesValue.toWidget(
                  data: (allRecipes) {
                    final recipes = allRecipes
                        .where((recipe) => recipe.status == status)
                        .toList();
                    return recipes.isEmpty
                        ? Text("No recipes")
                        : MasonryGridView.extent(
                            maxCrossAxisExtent: 250,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              return RecipesCard(recipe);
                            },
                          );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
