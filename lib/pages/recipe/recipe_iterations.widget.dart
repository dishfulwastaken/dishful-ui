import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/async_error.widget.dart';
import 'package:dishful/common/widgets/async_loading.widget.dart';
import 'package:dishful/pages/recipe/recipe_iterations_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeIterations extends ConsumerWidget {
  late final MyProvider<List<RecipeIteration?>> recipeIterationsProvider;

  RecipeIterations(String id) {
    recipeIterationsProvider = getAllProvider(
      DbService.publicDb.recipeIteration(id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return recipeIterationsProvider.when(
      ref,
      loading: asyncLoading,
      error: asyncError,
      data: (recipeIterations) {
        return recipeIterations.isEmpty
            ? Text('No iterations')
            : ListView.builder(
                itemCount: recipeIterations.length,
                itemBuilder: (context, index) {
                  final recipeIteration = recipeIterations[index]!;
                  return RecipeIterationsCard(recipeIteration);
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              );
      },
    );
  }
}