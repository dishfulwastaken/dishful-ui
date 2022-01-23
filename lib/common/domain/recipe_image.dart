import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_image.g.dart';

final uuid = Uuid();

@JsonSerializable()
class RecipeImage extends Serializable {
  final String id;
  final String bucketPath;
  final String blurHash;
  final int blurComponentX;
  final int blurComponentY;

  RecipeImage({
    required this.id,
    required this.bucketPath,
    required this.blurHash,
    required this.blurComponentX,
    required this.blurComponentY,
  });

  RecipeImage.create({
    required this.bucketPath,
    required this.blurHash,
    required this.blurComponentX,
    required this.blurComponentY,
  }) : id = uuid.v1();
}

class RecipeImageSerializer extends Serializer<RecipeImage> {
  const RecipeImageSerializer();
  RecipeImage fromJson(Map<String, dynamic> json) =>
      _$RecipeImageFromJson(json);
  Map<String, dynamic> toJson(RecipeImage data) => _$RecipeImageToJson(data);
}
