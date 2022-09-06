import 'package:animations/animations.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/datetime.dart';
import 'package:dishful/common/data/intersperse.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/preferences.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/widgets/dishful_empty.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Iterations extends ConsumerWidget {
  final String recipeId;
  final Recipe? initialRecipe;
  final AsyncValue<Iteration?> iterationValue;
  final AsyncValueProvider<List<Iteration>> iterationsProvider;
  final StateProvider<String?> selectedIterationIdProvider;

  Iterations(
    this.recipeId,
    this.initialRecipe,
    this.iterationValue, {
    required this.iterationsProvider,
    required this.selectedIterationIdProvider,
  });

  Future<void> selectIteration(WidgetRef ref, String iterationId) async {
    await PreferencesService.setLastOpenedIteration(
      recipeId: recipeId,
      lastOpenedIterationId: iterationId,
    );
    ref.set(selectedIterationIdProvider, iterationId);
  }

  Widget closedBuilder(BuildContext context, void Function() open) {
    final text = iterationValue.toWidget(
      loading: Text('Loading...', style: context.bodySmall),
      data: (iteration) => Text(
        iteration?.title ?? 'Select an iteration',
        style: context.bodySmall,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fork_right_rounded),
          Container(width: 8),
          text,
          Spacer(),
          Icon(Icons.expand_more_rounded),
        ],
      ),
    );
  }

  Widget openBuilder(
    BuildContext context,
    void Function() close,
    String? iterationId,
  ) {
    final title = iterationValue.whenData(
      (iteration) => iteration?.title ?? 'Select an iteration',
    );
    final createdAt = iterationValue.whenData(
      (iteration) => iteration?.createdAt,
    );
    final changes = iterationValue.whenData(
      (iteration) => iteration?.changes,
    );
    final hasSelectedIteration = iterationValue.valueOrNull != null;

    return DishfulScaffold(
      title: title.valueOrNull ?? 'No iteration selected',
      subtitle: createdAt.valueOrNull?.toString(),
      leading: (_) => DishfulIconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: close,
      ),
      body: (_) {
        final changesList = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Changes', style: context.bodySmall),
            Container(height: 4),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: changes.valueOrNull
                      ?.map((change) => Text(change.id))
                      .toList() ??
                  [],
            ),
            Container(height: 12),
          ],
        );
        final otherIterationsList = Consumer(
          builder: (context, ref, child) {
            final iterationsValue = ref.watch(iterationsProvider);

            return iterationsValue.toWidget(data: (iterations) {
              final otherIterations = iterations.where(
                (iteration) => iteration.id != iterationId,
              );
              final emptyIterations = DishfulEmpty(
                subject: 'iteration',
                onPressed: () => print('whatever'),
              );

              return iterations.isEmpty
                  ? emptyIterations
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasSelectedIteration)
                          Text(
                            'Select a different iteration',
                            style: context.bodySmall,
                          ),
                        Container(height: 4),
                        otherIterations.isEmpty
                            ? emptyIterations
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: otherIterations
                                    .map<Widget>(
                                      (iteration) {
                                        final titleText = iteration.title ??
                                            'Iteration #${iterations.indexOf(iteration) + 1}';

                                        return ListTile(
                                          title: Text(
                                            titleText,
                                            style: context.bodyMedium,
                                          ),
                                          subtitle: Text(
                                            iteration.createdAt.formatted,
                                            style: context.labelMedium,
                                          ),
                                          onTap: () {
                                            selectIteration(ref, iteration.id);
                                            RouteService.goRecipe(
                                              recipeId,
                                              recipe: initialRecipe,
                                              iterationId: iteration.id,
                                            );
                                            close();
                                          },
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          trailing: Icon(
                                            Icons.chevron_right_rounded,
                                          ),
                                        );
                                      },
                                    )
                                    .toList()
                                    .intersperse(Container(height: 8))
                                    .toList(),
                              )
                      ],
                    );
            });
          },
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasSelectedIteration) changesList,
            otherIterationsList
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iterationId = ref.watch(selectedIterationIdProvider);

    return OpenContainer(
      closedElevation: 0,
      closedBuilder: (context, state) => closedBuilder(context, state),
      openBuilder: (context, state) => openBuilder(context, state, iterationId),
    );
  }
}
