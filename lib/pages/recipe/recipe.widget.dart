import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/async_error.widget.dart';
import 'package:dishful/common/widgets/async_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipePage extends ConsumerWidget {
  late final AutoDisposeStreamProvider<RecipeMeta?> recipeProvider;

  RecipePage(String id) {
    recipeProvider = getProvider(DbService.privateDb.recipeMeta, id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeProvider);

    return recipeAsync.when(
      loading: asyncLoading,
      error: asyncError,
      data: (recipe) {
        final noRecipe = recipe == null;
        return noRecipe
            ? Text('No recipe')
            : Scaffold(
                appBar: AppBar(title: Text(recipe!.name)),
                body: Text(''),
              );
      },
    );
  }
}
