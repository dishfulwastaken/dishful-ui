import 'package:dishful/common/services/db.service.dart';

class Recipe extends Serializable {
  late String id;
  late String name;
  int? serves;
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

  /// TODO: only store difference with recipe.
  late dynamic diff;
  String? reviewId;

  Map<String, dynamic> toMap() {
    return {};
  }

  static RecipeIteration fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}

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

enum RecipeStatus { perfected, inDevelopment, notStarted }

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
