class Recipe {
  late String id;
  late String name;
  int? serves;
  late Duration duration;
  late RecipeStatus status;
  late List<String> iterationIds;
  late List<String> ingredientIds;
  late List<String> stepIds;
  String? reviewId;
}

class RecipeIteration {
  late String id;
  late String recipeId;
  late String name;

  /// TODO: only store difference with recipe.
  late dynamic diff;
  String? reviewId;
}

class RecipeIngredient {
  late String id;
  late String recipeId;
  late String name;
  late RecipeIngredientQuantity quantity;

  /// Each substitute may require multiple ingredients to be replaced.
  List<List<RecipeIngredientQuantity>>? substitutes;
}

class RecipeStep {
  late String id;
  late String recipeId;
  late int position;
  late String title;
  String? description;
  Duration? timer;
}

enum RecipeStatus { perfected, inDevelopment, notStarted }

class RecipeIngredientQuantity {
  late RecipeIngredientUnit unit;
  late double amount;
}

enum RecipeIngredientUnit { l, ml, kg, g, tsp, tbsp, cup, ounce }

class RecipeReview {
  late String id;
  late String parentId;
  late int rating;
  String? review;
}
