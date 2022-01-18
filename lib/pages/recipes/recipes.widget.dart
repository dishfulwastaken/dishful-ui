import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/common/widgets/async_loading.widget.dart';
import 'package:dishful/common/widgets/editable.widget.dart';
import 'package:dishful/pages/recipes/recipes_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishful/common/widgets/async_error.widget.dart';

class RecipesPage extends ConsumerWidget {
  late final AsyncValueProvider<List<RecipeMeta?>> recipesProvider;

  RecipesPage() {
    recipesProvider = getAllProvider(DbService.publicDb.recipeMeta());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesValue = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(title: EditableTextField()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DbService.publicDb.recipeMeta().create(randomRecipeMeta);
        },
        child: const Icon(Icons.plus_one_rounded),
      ),
      body: recipesValue.when(
        loading: asyncLoading,
        error: asyncError,
        data: (recipes) {
          return recipes.isEmpty
              ? Text('No recipes')
              : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index]!;
                    return RecipesCard(recipe);
                  },
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                );
        },
      ),
    );
  }
}
