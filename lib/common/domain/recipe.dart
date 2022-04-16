import 'package:dishful/common/data/swap.dart';
import 'package:dishful/common/domain/change.dart';
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

  Recipe applyChange(Change change) {
    switch (change.type) {
      case ChangeType.editServes:
        return copyWith(serves: change.newServes);
      case ChangeType.editSpiceLevel:
        return copyWith(spiceLevel: change.newSpiceLevel);
      case ChangeType.editCookTime:
        return copyWith(cookTime: change.newCookTime);
      case ChangeType.editPrepTime:
        return copyWith(prepTime: change.newPrepTime);
      case ChangeType.editIngredient:
        final newIngredient = change.newIngredient!;
        final newIngredients = ingredients.map(
          (ingredient) =>
              ingredient.id == newIngredient.id ? newIngredient : ingredient,
        );
        return copyWith(ingredients: newIngredients.toList());
      case ChangeType.removeIngredient:
        final oldIngredientId = change.newIngredient!.id;
        final newIngredients = ingredients.where(
          (ingredient) => ingredient.id != oldIngredientId,
        );
        return copyWith(ingredients: newIngredients.toList());
      case ChangeType.addIngredient:
        final newIngredients = [...ingredients, change.newIngredient!];
        return copyWith(ingredients: newIngredients.toList());
      case ChangeType.editInstruction:
        final newInstruction = change.newInstruction!;
        final newInstructions = instructions.map(
          (instruction) => instruction.id == newInstruction.id
              ? newInstruction
              : instruction,
        );
        return copyWith(instructions: newInstructions.toList());
      case ChangeType.removeInstruction:
        final oldInstructionId = change.newInstruction!.id;
        final newInstructions = instructions.where(
          (instruction) => instruction.id != oldInstructionId,
        );
        return copyWith(instructions: newInstructions.toList());
      case ChangeType.addInstruction:
        final newInstructions = [...instructions, change.newInstruction!];
        return copyWith(instructions: newInstructions.toList());
      case ChangeType.swapInstructions:
        final newInstructions = instructions.swapFirstWhere(
          (instruction) => [
            change.swapInstructionIdOne,
            change.swapInstructionIdTwo
          ].contains(instruction.id),
        );
        return copyWith(instructions: newInstructions.toList());
      case ChangeType.removeDiet:
        final newDiets = diets!.where((diet) => diet != change.newDiet);
        return copyWith(diets: newDiets.toList());
      case ChangeType.addDiet:
        final newDiets = [...(diets ?? <RecipeDiet>[]), change.newDiet!];
        return copyWith(diets: newDiets.toList());
    }
  }
}

class RecipeSerializer extends Serializer<Recipe> {
  const RecipeSerializer();
  Recipe fromJson(Json json) => _$RecipeFromJson(json);
  Json toJson(Recipe data) => _$RecipeToJson(data);
}

enum RecipeStatus { perfected, iterating, dropped }

enum RecipeDiet { none, vegetarian, vegan, gluttenFree }
