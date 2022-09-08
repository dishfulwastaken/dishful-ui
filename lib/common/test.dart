import 'dart:math';

import 'package:dishful/common/data/maybe.dart';
import 'package:dishful/common/data/units.dart';
import 'package:dishful/common/domain/change.dart';
import 'package:dishful/common/domain/ingredient.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/domain/instruction.dart';
import 'package:dishful/common/domain/review.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/ingress.service.dart';
import 'package:faker/faker.dart';

final r = Random();
final f = Faker();

List<T> generateAtMost<T>(
  int max,
  T Function() generator, {
  int? min,
}) {
  return List.filled(f.randomGenerator.integer(max, min: min ?? 0), 0)
      .map((_) => generator.call())
      .toList();
}

Duration get randomDuration => Duration(
      hours: f.randomGenerator.integer(2),
      minutes: f.randomGenerator.integer(5) * 10,
    );

Recipe get randomRecipe => Recipe(
      id: f.guid.guid(),
      roles: {AuthService.currentUser.uid: Role.owner},
      name: f.food.dish(),
      description: f.lorem
          .sentences(f.randomGenerator.integer(4, min: 1))
          .reduce((acc, cur) => "$acc $cur"),
      iterationCount: 0,
      status: f.randomGenerator.element(Status.values),
      createdAt: f.date.dateTime(),
      pictures: [],
      cookTime: randomDuration,
      prepTime: randomDuration,
      ingredients: generateAtMost(15, () => randomIngredient),
      instructions: generateAtMost(12, () => randomInstruction),
      serves: f.randomGenerator.integer(4, min: 1),
      updatedAt: f.date.dateTime(),
      diets: generateAtMost(3, () => f.randomGenerator.element(Diet.values)),
      spiceLevel: f.randomGenerator.element(SpiceLevel.values),
    );

Iteration randomIteration(Recipe recipe, String parentId) => Iteration(
      id: f.guid.guid(),
      recipeId: recipe.id,
      createdAt: f.date.dateTime(),
      updatedAt: f.date.dateTime(),
      parentId: parentId,
      changes: generateAtMost(3, () => randomChange(recipe), min: 1),
      reviews: [randomReview],
      title: f.sport.name(),
    );

Review get randomReview => Review(
      id: f.guid.guid(),
      reviewerId: f.guid.guid(),
      rating: f.randomGenerator.decimal() * 10,
      review: f.lorem.sentence(),
      pictures: [],
      createdAt: f.date.dateTime(),
    );

Change randomChange(Recipe originalRecipe) {
  final type = f.randomGenerator.element(ChangeType.values);
  final changedIngredientId = originalRecipe.ingredients.maybeFirst?.id;
  final changedInstructionId = originalRecipe.instructions.maybeFirst?.id;

  return Change(
    id: f.guid.guid(),
    type: type,
    newServes: f.randomGenerator.integer(4, min: 1),
    newSpiceLevel: f.randomGenerator.element(SpiceLevel.values),
    newCookTime: randomDuration,
    newPrepTime: randomDuration,
    newIngredient: changedIngredientId != null
        ? randomIngredient.copyWith(id: changedIngredientId)
        : null,
    newInstruction: changedInstructionId != null
        ? randomInstruction.copyWith(id: changedInstructionId)
        : null,
    newDiet: type == ChangeType.removeDiet
        ? f.randomGenerator.element(originalRecipe.diets ?? [])
        : f.randomGenerator.element(Diet.values),
  );
}

Ingredient get randomIngredient => Ingredient(
      id: f.guid.guid(),
      name: f.food.cuisine(),
      amount: (f.randomGenerator.decimal(min: 0.1) * 10).roundToDouble(),
      unit: f.randomGenerator.element(CookingUnit.values),
      substitutes: generateAtMost(
        2,
        () => Ingredient(
          id: f.guid.guid(),
          name: f.food.cuisine(),
          amount: (f.randomGenerator.decimal(min: 0.1) * 10).roundToDouble(),
          unit: f.randomGenerator.element(CookingUnit.values),
        ),
      ),
    );

Instruction get randomInstruction => Instruction(
      id: f.guid.guid(),
      title: f.lorem.words(3).join(' '),
      description: f.randomGenerator.boolean() ? f.lorem.sentence() : null,
    );

void main() async {
  final i = IngressService.forUrl(testUrlA);
  await i.init();
  i.recipe;
}
