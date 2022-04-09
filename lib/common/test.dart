import 'dart:math';

import 'package:dishful/common/domain/ingredient.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/domain/instruction.dart';
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

Recipe get randomRecipe => Recipe(
      id: f.guid.guid(),
      ownerId: f.guid.guid(),
      name: f.food.dish(),
      description: f.lorem
          .sentences(f.randomGenerator.integer(4, min: 1))
          .reduce((acc, cur) => "$acc $cur"),
      inspiration: f.lorem.sentence(),
      iterationCount: 0,
      status: f.randomGenerator.element(RecipeStatus.values),
      createdAt: f.date.dateTime(),
      pictures: [],
      cookTime: randomDuration,
      prepTime: randomDuration,
      ingredients: generateAtMost(5, () => randomIngredient),
      instructions: generateAtMost(8, () => randomInstruction),
      serves: f.randomGenerator.integer(4, min: 1),
      updatedAt: f.date.dateTime(),
    );

Iteration randomIteration(String parentId) => Iteration(
      id: f.guid.guid(),
      createdAt: f.date.dateTime(),
      updatedAt: f.date.dateTime(),
      parentId: parentId,
      changes: [],
      reviews: [],
    );

Ingredient get randomIngredient => Ingredient(
      id: f.guid.guid(),
      name: f.food.cuisine(),
      amount: f.randomGenerator.decimal(min: 0.1) * 10,
      unit: f.randomGenerator.element(IngredientUnit.values),
    );

Instruction get randomInstruction => Instruction(
      id: f.guid.guid(),
      position: f.randomGenerator.integer(100),
      description: f.lorem.sentence(),
    );

void main() async {
  final i = IngressService.forUrl(testUrlA);
  await i.init();
  i.recipe;
}
