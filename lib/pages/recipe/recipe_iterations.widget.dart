import 'package:animations/animations.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/datetime.dart';
import 'package:dishful/common/data/intersperse.dart';
import 'package:dishful/common/data/maybe.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/preferences.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/widgets/dishful_empty.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_text.widget.dart';
import 'package:dishful/common/widgets/dishful_menu.widget.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timelines/timelines.dart';

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

  Future<void> selectIteration(WidgetRef ref, String? iterationId) async {
    if (iterationId == null) {
      await PreferencesService.removeLastOpenedIteration(recipeId: recipeId);
    } else {
      await PreferencesService.setLastOpenedIteration(
        recipeId: recipeId,
        lastOpenedIterationId: iterationId,
      );
    }

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
      leading: (_) => DishfulIconButton(
        icon: Icon(Icons.close_rounded),
        onPressed: close,
      ),
      title: 'Iterations',
      subtitle: 'Select an iteration node',
      body: (_) {
        final timeline = Consumer(
          builder: (context, ref, child) {
            final iterationsValue = ref.watch(iterationsProvider);

            return iterationsValue.toWidget(data: (iterations) {
              final emptyIterations = DishfulEmpty(
                subject: 'iteration',
                onPressed: () => print('whatever'),
              );

              iterations.sort((a, b) => a.createdAt.compareTo(b.createdAt));

              return iterations.isEmpty
                  ? emptyIterations
                  : Flexible(
                      child: FixedTimeline(
                        theme: TimelineThemeData(color: Palette.lightGrey),
                        children: [
                          TimelineTile(
                            contents: Container(height: 68),
                            node: TimelineNode(
                              endConnector: DashedLineConnector(),
                              indicator: Indicator.widget(
                                child: DishfulMenuItem(
                                  iconData: Icons.add_rounded,
                                  text: 'New',
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                          ...iterations.map((iteration) {
                            final isFirst =
                                iteration.id == iterations.maybeFirst?.id;
                            final isSelectedIteration =
                                iteration.id == iterationValue.valueOrNull?.id;

                            final index = iterations.indexOf(iteration);
                            final titleText =
                                iteration.title ?? 'Iteration #${index + 1}';

                            return TimelineTile(
                              oppositeContents: Container(
                                margin: const EdgeInsets.all(14),
                                child: Text(
                                  iteration.createdAt.formatted,
                                  style: context.labelMedium,
                                ),
                              ),
                              contents: isSelectedIteration
                                  ? Container(
                                      margin: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            titleText,
                                            style: context.titleSmall,
                                          ),
                                          Container(height: 4),
                                          Text(iteration.changes.length
                                              .toString()),
                                          Text(iteration.reviews.length
                                              .toString()),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(16),
                                      child: Text(
                                        titleText,
                                        style: context.bodySmall,
                                      ),
                                    ),
                              node: GestureDetector(
                                onTap: () {
                                  selectIteration(ref, iteration.id);
                                  RouteService.goRecipe(
                                    recipeId,
                                    recipe: initialRecipe,
                                    iterationId: iteration.id,
                                  );
                                  close();
                                },
                                child: TimelineNode(
                                  startConnector: isFirst
                                      ? DashedLineConnector()
                                      : SolidLineConnector(),
                                  endConnector: SolidLineConnector(),
                                  indicator: isSelectedIteration
                                      ? Indicator.dot(
                                          color: Palette.primary,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          ),
                                        )
                                      : Indicator.dot(),
                                ),
                              ),
                            );
                          }),
                          TimelineTile(
                            contents: Container(height: 52),
                            node: GestureDetector(
                              onTap: () {
                                selectIteration(ref, null);
                                RouteService.goRecipe(
                                  recipeId,
                                  recipe: initialRecipe,
                                  iterationId: null,
                                );
                                close();
                              },
                              child: TimelineNode(
                                startConnector: SolidLineConnector(),
                                indicator: Indicator.dot(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.flag_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text('Original', style: context.titleSmall),
                          if (initialRecipe != null)
                            Text(
                              initialRecipe!.createdAt.formatted,
                              style: context.labelMedium,
                            )
                        ],
                      ),
                    );
            });
          },
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [timeline],
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
