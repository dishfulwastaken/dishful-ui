import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/pages/recipe/recipe_iterations_card.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeIterations extends ConsumerWidget {
  late final AsyncValueProvider<List<RecipeIteration>> recipeIterationsProvider;
  final transformationController = TransformationController(
      // Matrix4.identity().scaled(0.5),
      );

  RecipeIterations(String id) {
    recipeIterationsProvider = getAllProvider(
      DbService.publicDb.recipeIteration(id),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeIterationsValue = ref.watch(recipeIterationsProvider);

    return recipeIterationsValue.toWidget(
      data: (recipeIterations) {
        final recipeIterationsList = recipeIterations.isEmpty
            ? Text("No iterations")
            : ListView.builder(
                itemCount: recipeIterations.length,
                itemBuilder: (context, index) {
                  final recipeIteration = recipeIterations[index];
                  return RecipeIterationsCard(recipeIteration);
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              );

        return InteractiveViewer(
          clipBehavior: Clip.antiAlias,
          transformationController: transformationController,
          boundaryMargin: EdgeInsets.symmetric(
            horizontal: context.width,
            vertical: context.height,
          ),
          minScale: 0.1,
          maxScale: 5.0,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.orange, Colors.red],
                stops: <double>[0.0, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}
