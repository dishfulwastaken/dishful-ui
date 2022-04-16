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
  final int? newSpiceLevel;
  final Duration? newCookTime;
  final Duration? newPrepTime;
  @NullableIngredientSerializer()
  final Ingredient? newIngredient;
  @NullableInstructionSerializer()
  final Instruction? newInstruction;
  final String? swapInstructionIdOne;
  final String? swapInstructionIdTwo;
  final RecipeDiet? newDiet;

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
