import 'package:dishful/common/services/db.service.dart';

class Recipe extends Serializable {
  late String id;
  late String name;
  late String description;
  String? inspiration;
  int? serves;
  int? spiceLevel;
  List<RecipeDiet>? diets;
  late RecipeDuration duration;
  late RecipeStatus status;
  late List<String> iterationIds;
  late List<String> ingredientIds;
  late List<String> stepIds;
  String? reviewId;

  Map<String, dynamic> toMap() {
    return {};
  }

  static Recipe fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  Recipe operator +(RecipeDiff diff) {
    var recipe = toMap();

    for (MapEntry<String, dynamic> entry in diff.entries) {
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
    var diff = Map<String, dynamic>();

    for (MapEntry<String, dynamic> entry in other.toMap().entries) {
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
}

class RecipeDuration {
  late Duration cook;
  late Duration prep;
  Duration get total => cook + prep;
}

class RecipeIteration extends Serializable {
  late String id;
  late String recipeId;
  late String name;

  late RecipeDiff diff;
  String? reviewId;

  Map<String, dynamic> toMap() {
    return {};
  }

  static RecipeIteration fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}

typedef RecipeDiff = Map<String, dynamic>;

class RecipeIngredient extends Serializable {
  late String id;
  late String recipeId;
  late String name;
  late RecipeIngredientQuantity quantity;

  /// Each substitute may require multiple ingredients to be replaced.
  List<List<RecipeIngredientQuantity>>? substitutes;

  Map<String, dynamic> toMap() {
    return {};
  }

  static RecipeIngredient fromMap(Map<String, dynamic> map) {
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

  Map<String, dynamic> toMap() {
    return {};
  }

  static RecipeStep fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}

enum RecipeStatus { perfected, iterating, dropped }
enum RecipeDiet { vegetarian, vegan, gluttenFree }

class RecipeIngredientQuantity {
  late RecipeIngredientUnit unit;
  late double amount;
}

enum RecipeIngredientUnit { l, ml, kg, g, tsp, tbsp, cup, ounce }

class RecipeReview extends Serializable {
  late String id;
  late String parentId;
  late int rating;
  String? review;

  Map<String, dynamic> toMap() {
    return {};
  }

  static RecipeReview fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}
