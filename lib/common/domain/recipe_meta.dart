import 'package:dishful/common/domain/recipe_image.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_meta.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class RecipeMeta extends Serializable {
  final String id;
  final String name;
  final String description;
  final String? inspiration;
  final int iterationCount;
  final RecipeStatus status;
  final DateTime createdAt;
  @RecipeImageSerializer()
  final List<RecipeImage> image;

  RecipeMeta({
    required this.id,
    required this.name,
    required this.description,
    this.inspiration,
    required this.iterationCount,
    required this.status,
    required this.createdAt,
    required this.image,
  });

  RecipeMeta.create({
    required this.name,
    required this.description,
    this.inspiration,
  })  : id = uuid.v1(),
        iterationCount = 0,
        createdAt = DateTime.now(),
        status = RecipeStatus.iterating,
        image = [];
}

class RecipeMetaSerializer extends Serializer<RecipeMeta> {
  const RecipeMetaSerializer();
  RecipeMeta fromJson(Json json) => _$RecipeMetaFromJson(json);
  Json toJson(RecipeMeta data) => _$RecipeMetaToJson(data);
}

enum RecipeStatus { perfected, iterating, dropped }
