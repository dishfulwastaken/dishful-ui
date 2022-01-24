import 'package:dishful/common/domain/recipe_image.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_review.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class RecipeReview extends Serializable {
  final String id;
  final String reviewerId;
  final int rating;
  final String? review;
  @RecipeImageSerializer()
  final List<RecipeImage>? images;

  RecipeReview({
    required this.id,
    required this.reviewerId,
    required this.rating,
    this.review,
    this.images,
  });

  RecipeReview.create({
    required this.reviewerId,
    required this.rating,
    this.review,
  })  : id = uuid.v1(),
        images = [];
}

class RecipeReviewSerializer extends Serializer<RecipeReview> {
  const RecipeReviewSerializer();
  RecipeReview fromJson(Json json) => _$RecipeReviewFromJson(json);
  Json toJson(RecipeReview data) => _$RecipeReviewToJson(data);
}
