import 'dart:math';

import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:faker/faker.dart';

final r = Random();
final f = Faker();

Duration get randomDuration => Duration(
      hours: f.randomGenerator.integer(2),
      minutes: f.randomGenerator.integer(5) * 10,
    );

RecipeMeta get randomRecipeMeta => RecipeMeta(
      id: f.guid.guid(),
      name: f.food.dish(),
      description: f.lorem.sentence(),
      inspiration: f.lorem.sentence(),
      status: f.randomGenerator.element(RecipeStatus.values),
      iterationIds: [],
      createdAt: f.date.dateTime(),
    );

RecipeIteration get randomRecipeIteration => RecipeIteration(
      id: f.guid.guid(),
      cookTime: randomDuration,
      prepTime: randomDuration,
      ingredients: [],
      steps: [],
      createdAt: f.date.dateTime(),
    );

void main() {}
