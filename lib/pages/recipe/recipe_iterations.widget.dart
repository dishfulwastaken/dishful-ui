import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/dishful_empty.widget.dart';
import 'package:dishful/pages/recipe/recipe_iterations_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Iterations extends ConsumerWidget {
  late final FutureProvider<List<Iteration>> recipeIterationsProvider;

  Iterations(String id) {
    recipeIterationsProvider = getAllProvider(
      DbService.publicDb.iterations(id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeIterationsValue = ref.watch(recipeIterationsProvider);

    return recipeIterationsValue.toWidget(
      data: (recipeIterations) {
        final recipeIterationsList = recipeIterations.isEmpty
            ? DishfulEmpty(subject: "iteration", onPressed: () {})
            : ListView.builder(
                itemCount: recipeIterations.length,
                itemBuilder: (context, index) {
                  final recipeIteration = recipeIterations[index];
                  return IterationsCard(recipeIteration);
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              );

        return recipeIterationsList;
      },
    );
  }
}
