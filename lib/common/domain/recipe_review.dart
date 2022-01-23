import 'package:dishful/common/domain/recipe_image.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_review.g.dart';

final uuid = Uuid();

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
  RecipeReview fromJson(Map<String, dynamic> json) =>
      _$RecipeReviewFromJson(json);
  Map<String, dynamic> toJson(RecipeReview data) => _$RecipeReviewToJson(data);
}
