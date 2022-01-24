import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:uuid/uuid.dart';

part 'generated/recipe_image.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class RecipeImage extends Serializable {
  final String id;
  final bool isLocal;
  late final String path;
  final String blurHash;
  final int width;
  final int height;

  RecipeImage({
    required this.id,
    required this.isLocal,
    required this.blurHash,
    required this.width,
    required this.height,
  });

  RecipeImage.create({
    required this.blurHash,
    required this.width,
    required this.height,
    this.isLocal = false,
  }) : id = uuid.v1();

  RecipeImage copyWithPath(String path) => copyWith()..path = path;
}

class RecipeImageSerializer extends Serializer<RecipeImage> {
  const RecipeImageSerializer();
  RecipeImage fromJson(Json json) => _$RecipeImageFromJson(json);
  Json toJson(RecipeImage data) => _$RecipeImageToJson(data);
}
