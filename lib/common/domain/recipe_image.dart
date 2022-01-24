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
  final String path;
  final String blurHash;
  final int blurComponentX;
  final int blurComponentY;

  RecipeImage({
    required this.id,
    required this.isLocal,
    required this.path,
    required this.blurHash,
    required this.blurComponentX,
    required this.blurComponentY,
  });

  RecipeImage.create({
    required this.path,
    required this.blurHash,
  })  : id = uuid.v1(),
        isLocal = true,
        blurComponentX = 4,
        blurComponentY = 3;
}

class RecipeImageSerializer extends Serializer<RecipeImage> {
  const RecipeImageSerializer();
  RecipeImage fromJson(Json json) => _$RecipeImageFromJson(json);
  Json toJson(RecipeImage data) => _$RecipeImageToJson(data);
}
