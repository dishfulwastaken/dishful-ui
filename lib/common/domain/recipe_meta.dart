import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/recipe_meta.g.dart';

@JsonSerializable()
class RecipeMeta extends Serializable {
  final String id;
  final String name;
  final String description;
  final String? inspiration;
  final RecipeStatus status;
  final DateTime createdAt;

  RecipeMeta({
    required this.id,
    required this.name,
    required this.description,
    this.inspiration,
    required this.status,
    required this.createdAt,
  });
}

class RecipeMetaSerializer extends Serializer<RecipeMeta> {
  const RecipeMetaSerializer();
  RecipeMeta fromJson(Map<String, dynamic> json) => _$RecipeMetaFromJson(json);
  Map<String, dynamic> toJson(RecipeMeta data) => _$RecipeMetaToJson(data);
}

enum RecipeStatus { perfected, iterating, dropped }
