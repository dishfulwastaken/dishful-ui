import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_ingredient.g.dart';

final uuid = Uuid();

@CopyWith()
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

  RecipeIngredient.create({
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutes,
  }) : id = uuid.v1();
}

class RecipeIngredientSerializer extends Serializer<RecipeIngredient> {
  const RecipeIngredientSerializer();
  RecipeIngredient fromJson(Json json) => _$RecipeIngredientFromJson(json);
  Json toJson(RecipeIngredient data) => _$RecipeIngredientToJson(data);
}

enum RecipeIngredientUnit { l, ml, kg, g, tsp, tbsp, cup, ounce }
