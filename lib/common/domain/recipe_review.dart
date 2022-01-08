import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'generated/recipe_review.g.dart';

final uuid = Uuid();

@JsonSerializable()
class RecipeReview extends Serializable {
  final String id;
  final int rating;
  final String? review;

  RecipeReview({
    required this.id,
    required this.rating,
    this.review,
  });

  RecipeReview.create({
    required this.rating,
    this.review,
  }) : id = uuid.v1();
}

class RecipeReviewSerializer extends Serializer<RecipeReview> {
  const RecipeReviewSerializer();
  RecipeReview fromJson(Map<String, dynamic> json) =>
      _$RecipeReviewFromJson(json);
  Map<String, dynamic> toJson(RecipeReview data) => _$RecipeReviewToJson(data);
}
