import 'dart:math';

import 'domain/recipe.dart';

final r = Random();

Recipe get getRandomRecipe => Recipe(
      id: (r.nextInt(100)).toString(),
      name: "Dish Title",
      description: "yummy",
      inspiration: "a dream",
      serves: r.nextInt(10),
      spiceLevel: r.nextInt(5),
      diets: null,
      cookTime: Duration.zero,
      prepTime: Duration(hours: 1),
      status: RecipeStatus.iterating,
      iterationIds: [],
      ingredientIds: [],
      stepIds: [],
      reviewId: "",
    );
