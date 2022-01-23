import 'package:dishful/common/domain/recipe_image.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_meta.g.dart';

final uuid = Uuid();

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
  final RecipeImage? image;

  RecipeMeta({
    required this.id,
    required this.name,
    required this.description,
    this.inspiration,
    required this.iterationCount,
    required this.status,
    required this.createdAt,
    this.image,
  });

  RecipeMeta.create({
    required this.name,
    required this.description,
    this.inspiration,
    this.image,
  })  : id = uuid.v1(),
        iterationCount = 0,
        createdAt = DateTime.now(),
        status = RecipeStatus.iterating;
}

class RecipeMetaSerializer extends Serializer<RecipeMeta> {
  const RecipeMetaSerializer();
  RecipeMeta fromJson(Map<String, dynamic> json) => _$RecipeMetaFromJson(json);
  Map<String, dynamic> toJson(RecipeMeta data) => _$RecipeMetaToJson(data);
}

enum RecipeStatus { perfected, iterating, dropped }
