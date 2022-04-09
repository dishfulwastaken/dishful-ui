import 'package:dishful/common/domain/ingredient.dart';
import 'package:dishful/common/domain/instruction.dart';
import 'package:dishful/common/domain/picture.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Recipe extends Serializable {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String? inspiration;
  final int iterationCount;
  final RecipeStatus status;

  final DateTime createdAt;
  final DateTime updatedAt;

  @PictureSerializer()
  final List<Picture> pictures;

  final int serves;
  final int? spiceLevel;
  final Duration cookTime;
  final Duration prepTime;
  @IngredientSerializer()
  final List<Ingredient> ingredients;
  @InstructionSerializer()
  final List<Instruction> instructions;
  final List<RecipeDiet>? diets;

  Recipe({
    required this.updatedAt,
    required this.serves,
    this.spiceLevel,
    required this.cookTime,
    required this.prepTime,
    required this.ingredients,
    required this.instructions,
    this.diets,
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    this.inspiration,
    required this.iterationCount,
    required this.status,
    required this.createdAt,
    required this.pictures,
  });

  Recipe.create({
    required this.serves,
    this.spiceLevel,
    required this.cookTime,
    required this.prepTime,
    required this.ingredients,
    required this.instructions,
    this.diets,
    required this.name,
    required this.description,
    this.inspiration,
  })  : id = uuid.v1(),
        ownerId = AuthService.currentUser!.uid,
        iterationCount = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        status = RecipeStatus.iterating,
        pictures = [];
}

class RecipeSerializer extends Serializer<Recipe> {
  const RecipeSerializer();
  Recipe fromJson(Json json) => _$RecipeFromJson(json);
  Json toJson(Recipe data) => _$RecipeToJson(data);
}

enum RecipeStatus { perfected, iterating, dropped }

enum RecipeDiet { none, vegetarian, vegan, gluttenFree }
