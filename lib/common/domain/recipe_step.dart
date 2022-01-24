import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_step.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class RecipeStep extends Serializable {
  final String id;
  final int position;
  final String? title;
  final String description;
  final Duration? timer;

  RecipeStep({
    required this.id,
    required this.position,
    this.title,
    required this.description,
    this.timer,
  });

  RecipeStep.create({
    required this.position,
    this.title,
    required this.description,
    this.timer,
  }) : id = uuid.v1();
}

class RecipeStepSerializer extends Serializer<RecipeStep> {
  const RecipeStepSerializer();
  RecipeStep fromJson(Json json) => _$RecipeStepFromJson(json);
  Json toJson(RecipeStep data) => _$RecipeStepToJson(data);
}
