import 'package:dishful/common/data/durations.dart';
import 'package:dishful/common/services/db.service.dart';

class Recipe extends Serializable {
  late String id;
  late String name;
  late String description;
  String? inspiration;
  int? serves;
  int? spiceLevel;
  List<RecipeDiet>? diets;
  late Duration cookTime;
  late Duration prepTime;
  late RecipeStatus status;
  late List<String> iterationIds;
  late List<String> ingredientIds;
  late List<String> stepIds;
  String? reviewId;

  // TODO: this
  // DateTime createdAt;
  // DateTime? updatedAt;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.inspiration,
    required this.serves,
    required this.spiceLevel,
    required this.diets,
    required this.cookTime,
    required this.prepTime,
    required this.status,
    required this.iterationIds,
    required this.ingredientIds,
    required this.stepIds,
    required this.reviewId,
  });

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "inspiration": inspiration,
      "serves": serves,
      "spiceLevel": spiceLevel,
      "diets": diets?.map((diet) => diet.toString()),
      "cookTime": cookTime.toString(),
      "prepTime": prepTime.toString(),
      "status": status.toString(),
      "iterationIds": iterationIds,
      "ingredientIds": ingredientIds,
      "stepIds": stepIds,
      "reviewId": reviewId,
    };
  }

  static Recipe fromMap(Map map) {
    return Recipe(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      inspiration: map["inspiration"],
      serves: map["serves"],
      spiceLevel: map["spiceLevel"],
      diets: map["diets"]?.map(parseRecipeDiet),
      cookTime: parseDuration(map["cookTime"]),
      prepTime: parseDuration(map["prepTime"]),
      status: parseRecipeStatus(map["status"]),
      iterationIds: map["iterationIds"],
      ingredientIds: map["ingredientIds"],
      stepIds: map["stepIds"],
      reviewId: map["reviewId"],
    );
  }

  Recipe operator +(RecipeDiff diff) {
    var recipe = toMap();

    for (MapEntry entry in diff.entries) {
      if (recipe.containsKey(entry.key)) {
        try {
          // If a + operator is defined, the diff will use it.
          recipe.update(entry.key, (value) => value + entry.value);
        } catch (e) {
          // Else, the diff will override the value in [recipe].
          recipe.update(entry.key, (value) => entry.value);
        }
      } else {
        recipe.putIfAbsent(entry.key, () => entry.value);
      }
    }

    return Recipe.fromMap(recipe);
  }

  RecipeDiff operator -(Recipe other) {
    var recipe = toMap();
    var diff = Map();

    for (MapEntry entry in other.toMap().entries) {
      var containsKey = recipe.containsKey(entry.key);
      var sameValue = recipe[entry.key] == entry.value;

      if (containsKey && !sameValue) {
        try {
          // If a - operator is defined, the diff will use it.
          diff.putIfAbsent(entry.key, () => recipe[entry.key] - entry.value);
        } catch (e) {
          // Else, the diff will take the value in [other].
          diff.putIfAbsent(entry.key, () => entry.value);
        }
      }
    }

    return diff;
  }

  Duration get totalTime => cookTime + prepTime;
}

class RecipeIteration extends Serializable {
  late String id;
  late String recipeId;
  late String name;

  late RecipeDiff diff;
  String? reviewId;

  // TODO: this
  // DateTime createdAt;

  Map toMap() {
    return {};
  }

  static RecipeIteration fromMap(Map map) {
    throw UnimplementedError();
  }
}

typedef RecipeDiff = Map;

class RecipeIngredient extends Serializable {
  late String id;
  late String recipeId;
  late String name;
  late RecipeIngredientQuantity quantity;

  /// Each substitute may require multiple ingredients to be replaced.
  List<List<RecipeIngredientQuantity>>? substitutes;

  Map toMap() {
    return {};
  }

  static RecipeIngredient fromMap(Map map) {
    throw UnimplementedError();
  }
}

class RecipeStep extends Serializable {
  late String id;
  late String recipeId;
  late int position;
  late String title;
  String? description;
  Duration? timer;

  Map toMap() {
    return {};
  }

  static RecipeStep fromMap(Map map) {
    throw UnimplementedError();
  }
}

enum RecipeStatus { perfected, iterating, dropped }
RecipeStatus parseRecipeStatus(String s) => RecipeStatus.values.firstWhere(
      (e) => e.toString() == s,
      orElse: () => RecipeStatus.iterating,
    );
enum RecipeDiet { none, vegetarian, vegan, gluttenFree }
RecipeDiet parseRecipeDiet(String s) => RecipeDiet.values.firstWhere(
      (e) => e.toString() == s,
      orElse: () => RecipeDiet.none,
    );

class RecipeIngredientQuantity {
  late RecipeIngredientUnit unit;
  late double amount;
}

enum RecipeIngredientUnit { l, ml, kg, g, tsp, tbsp, cup, ounce }
RecipeIngredientUnit parseRecipeIngredientUnit(String s) =>
    RecipeIngredientUnit.values.firstWhere(
      (e) => e.toString() == s,
      orElse: () => RecipeIngredientUnit.g,
    );

class RecipeReview extends Serializable {
  late String id;
  late String parentId;
  late int rating;
  String? review;

  Map toMap() {
    return {};
  }

  static RecipeReview fromMap(Map map) {
    throw UnimplementedError();
  }
}
