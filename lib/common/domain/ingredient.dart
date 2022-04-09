import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/ingredient.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Ingredient extends Serializable {
  final String id;
  final String name;
  final double amount;
  final IngredientUnit unit;

  /// Each substitute may require multiple ingredients to be replaced,
  /// e.g. 1 cup of milk -> [[1 cup water, 1 tbsp malt], [1 cup oat milk]]
  @IngredientSerializer()
  final List<List<Ingredient>>? substitutes;

  Ingredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutes,
  });

  Ingredient.create({
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutes,
  }) : id = uuid.v1();
}

class IngredientSerializer extends Serializer<Ingredient> {
  const IngredientSerializer();
  Ingredient fromJson(Json json) => _$IngredientFromJson(json);
  Json toJson(Ingredient data) => _$IngredientToJson(data);
}

enum IngredientUnit { l, ml, kg, g, tsp, tbsp, cup, ounce }
