import 'dart:math';

import 'package:dishful/common/domain/recipe_ingredient.dart';
import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/domain/recipe_step.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/ingress.service.dart';
import 'package:faker/faker.dart';

final r = Random();
final f = Faker();

List<T> generateAtMost<T extends Serializable>(
  int max,
  T Function() generator,
) {
  return List.filled(f.randomGenerator.integer(max), 0)
      .map((_) => generator.call())
      .toList();
}

Duration get randomDuration => Duration(
      hours: f.randomGenerator.integer(2),
      minutes: f.randomGenerator.integer(5) * 10,
    );

RecipeMeta get randomRecipeMeta => RecipeMeta(
      id: f.guid.guid(),
      name: f.food.dish(),
      description: f.lorem
          .sentences(f.randomGenerator.integer(3, min: 1))
          .reduce((acc, cur) => "$acc $cur"),
      inspiration: f.lorem.sentence(),
      iterationCount: 0,
      status: f.randomGenerator.element(RecipeStatus.values),
      createdAt: f.date.dateTime(),
    );

RecipeIteration randomRecipeIteration(String parentId) => RecipeIteration(
      id: f.guid.guid(),
      cookTime: randomDuration,
      prepTime: randomDuration,
      ingredients: generateAtMost(5, () => randomRecipeIngredient),
      steps: generateAtMost(8, () => randomRecipeStep),
      createdAt: f.date.dateTime(),
      parentId: parentId,
    );

RecipeIngredient get randomRecipeIngredient => RecipeIngredient(
      id: f.guid.guid(),
      name: f.food.cuisine(),
      amount: f.randomGenerator.decimal(min: 0.1) * 10,
      unit: f.randomGenerator.element(RecipeIngredientUnit.values),
    );

RecipeStep get randomRecipeStep => RecipeStep(
      id: f.guid.guid(),
      position: f.randomGenerator.integer(100),
      description: f.lorem.sentence(),
    );

void main() async {
  final i = IngressService.forUrl(testUrlA);
  await i.init();
  i.recipeMeta;
}
