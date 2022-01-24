import 'package:dishful/common/domain/recipe_ingredient.dart';
import 'package:dishful/common/domain/recipe_step.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_iteration.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class RecipeIteration extends Serializable {
  final String id;
  final String? parentId;
  final String? reviewId;
  final int? serves;
  final int? spiceLevel;
  final Duration cookTime;
  final Duration prepTime;
  @RecipeIngredientSerializer()
  final List<RecipeIngredient> ingredients;
  @RecipeStepSerializer()
  final List<RecipeStep> steps;
  final List<RecipeDiet>? diets;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RecipeIteration({
    required this.id,
    this.parentId,
    this.reviewId,
    this.serves,
    this.spiceLevel,
    required this.cookTime,
    required this.prepTime,
    required this.ingredients,
    required this.steps,
    this.diets,
    required this.createdAt,
    this.updatedAt,
  });

  RecipeIteration.create({
    this.parentId,
    this.reviewId,
    this.serves,
    this.spiceLevel,
    required this.cookTime,
    required this.prepTime,
    required this.ingredients,
    required this.steps,
    this.diets,
    this.updatedAt,
  })  : id = uuid.v1(),
        createdAt = DateTime.now();
}

class RecipeIterationSerializer extends Serializer<RecipeIteration> {
  const RecipeIterationSerializer();
  RecipeIteration fromJson(Json json) => _$RecipeIterationFromJson(json);
  Json toJson(RecipeIteration data) => _$RecipeIterationToJson(data);
}

enum RecipeDiet { none, vegetarian, vegan, gluttenFree }
