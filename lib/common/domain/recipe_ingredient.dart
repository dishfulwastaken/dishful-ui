import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/recipe_ingredient.g.dart';

@JsonSerializable()
class RecipeIngredient extends Serializable {
  final String id;
  final String name;
  final double amount;
  final RecipeIngredientUnit unit;

  /// Each substitute may require multiple ingredients to be replaced,
  /// e.g. 1 cup of milk -> [[1 cup water, 1 tbsp malt], [1 cup oat milk]]
  @RecipeIngredientSerializer()
  final List<List<RecipeIngredient>>? substitutes;

  RecipeIngredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutes,
  });
}

class RecipeIngredientSerializer extends Serializer<RecipeIngredient> {
  const RecipeIngredientSerializer();
  RecipeIngredient fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
  Map<String, dynamic> toJson(RecipeIngredient data) =>
      _$RecipeIngredientToJson(data);
}

enum RecipeIngredientUnit { l, ml, kg, g, tsp, tbsp, cup, ounce }
