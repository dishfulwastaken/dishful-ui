import 'dart:math';

import 'package:faker/faker.dart';

import 'domain/recipe.dart';

final r = Random();
final f = Faker();

Duration get randomDuration => Duration(
      hours: f.randomGenerator.integer(2),
      minutes: f.randomGenerator.integer(5) * 10,
    );

Recipe get randomRecipe => Recipe(
      id: f.randomGenerator.integer(100).toString(),
      name: f.food.dish(),
      description: f.lorem.sentence(),
      inspiration: f.lorem.sentence(),
      serves: f.randomGenerator.integer(10, min: 1),
      spiceLevel: f.randomGenerator.integer(5),
      diets: [f.randomGenerator.element(RecipeDiet.values)],
      cookTime: randomDuration,
      prepTime: randomDuration,
      status: f.randomGenerator.element(RecipeStatus.values),
      iterationIds: [],
      ingredientIds: [],
      stepIds: [],
      reviewId: "",
      createdAt: f.date.dateTime(),
      updatedAt: f.date.dateTime(),
    );
