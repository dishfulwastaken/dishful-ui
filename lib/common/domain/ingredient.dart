import 'package:dishful/common/data/units.dart';
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
  final CookingUnit unit;

  @IngredientSerializer()
  final List<Ingredient> substitutes;

  Ingredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutes = const [],
  });

  Ingredient.create({
    required this.name,
    required this.amount,
    required this.unit,
    this.substitutes = const [],
  }) : id = uuid.v1();

  String toString() {
    final isPlural = amount != 1;
    final pluralizedUnit = isPlural ? unit.plural : unit.name;

    return "$amount ${pluralizedUnit} of $name";
  }
}

class IngredientSerializer extends Serializer<Ingredient> {
  const IngredientSerializer();
  Ingredient fromJson(Json json) => _$IngredientFromJson(json);
  Json toJson(Ingredient data) => _$IngredientToJson(data);
}

class NullableIngredientSerializer extends Serializer<Ingredient?> {
  const NullableIngredientSerializer();
  Ingredient? fromJson(Json json) => _$IngredientFromJson(json);
  Json toJson(Ingredient? data) => data == null ? {} : _$IngredientToJson(data);
}
