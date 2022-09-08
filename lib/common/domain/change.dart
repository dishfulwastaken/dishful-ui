import 'package:dishful/common/domain/ingredient.dart';
import 'package:dishful/common/domain/instruction.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/change.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Change extends Serializable {
  final String id;
  final ChangeType type;

  final int? newServes;
  final SpiceLevel? newSpiceLevel;
  final Duration? newCookTime;
  final Duration? newPrepTime;
  @NullableIngredientSerializer()
  final Ingredient? newIngredient;
  @NullableInstructionSerializer()
  final Instruction? newInstruction;
  final String? swapInstructionIdOne;
  final String? swapInstructionIdTwo;
  final Diet? newDiet;

  Change({
    required this.id,
    required this.type,
    this.newServes,
    this.newSpiceLevel,
    this.newCookTime,
    this.newPrepTime,
    this.newIngredient,
    this.newInstruction,
    this.swapInstructionIdOne,
    this.swapInstructionIdTwo,
    this.newDiet,
  }) : assert(
          type == ChangeType.editServes && newServes != null ||
              type == ChangeType.editSpiceLevel && newSpiceLevel != null ||
              type == ChangeType.editCookTime && newCookTime != null ||
              type == ChangeType.editPrepTime && newPrepTime != null ||
              type == ChangeType.editIngredient && newIngredient != null ||
              type == ChangeType.removeIngredient && newIngredient != null ||
              type == ChangeType.addIngredient && newIngredient != null ||
              type == ChangeType.editInstruction && newInstruction != null ||
              type == ChangeType.removeInstruction && newInstruction != null ||
              type == ChangeType.addInstruction && newInstruction != null ||
              type == ChangeType.swapInstructions &&
                  swapInstructionIdOne != null &&
                  swapInstructionIdTwo != null ||
              type == ChangeType.removeDiet && newDiet != null ||
              type == ChangeType.addDiet && newDiet != null,
        );

  Change.create({
    required this.type,
    this.newServes,
    this.newSpiceLevel,
    this.newCookTime,
    this.newPrepTime,
    this.newIngredient,
    this.newInstruction,
    this.swapInstructionIdOne,
    this.swapInstructionIdTwo,
    this.newDiet,
  }) : id = uuid.v1();

  /// TODO: update this method to take the current recipe so that we can create
  /// much more human-friendly and descriptive strings.
  String toString() {
    switch (type) {
      case ChangeType.editServes:
        return 'Update serves to $newServes';
      case ChangeType.editSpiceLevel:
        return 'Update spice level to $newSpiceLevel';
      case ChangeType.editCookTime:
        return 'Update cook time to $newCookTime';
      case ChangeType.editPrepTime:
        return 'Update prep time to $newPrepTime';
      case ChangeType.editIngredient:
        return 'Update ingredient to $newIngredient';
      case ChangeType.removeIngredient:
        return 'Remove ingredient: $newIngredient';
      case ChangeType.addIngredient:
        return 'Add ingredient: $newIngredient';
      case ChangeType.editInstruction:
        return 'Update instruction to $newInstruction';
      case ChangeType.removeInstruction:
        return 'Remove instruction: $newInstruction';
      case ChangeType.addInstruction:
        return 'Add instruction: $newInstruction';
      case ChangeType.swapInstructions:
        return 'Swap instructions: $swapInstructionIdOne, $swapInstructionIdOne';
      case ChangeType.removeDiet:
        return 'Remove diet: $newDiet';
      case ChangeType.addDiet:
        return 'Add diet: $newDiet';
    }
  }
}

class ChangeSerializer extends Serializer<Change> {
  const ChangeSerializer();
  Change fromJson(Json json) => _$ChangeFromJson(json);
  Json toJson(Change data) => _$ChangeToJson(data);
}

enum ChangeType {
  editServes,

  editSpiceLevel,

  editCookTime,
  editPrepTime,

  editIngredient,
  removeIngredient,
  addIngredient,

  editInstruction,
  removeInstruction,
  addInstruction,
  swapInstructions,

  removeDiet,
  addDiet,
}
