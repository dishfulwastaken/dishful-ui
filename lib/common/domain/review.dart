import 'package:dishful/common/domain/picture.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/review.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Review extends Serializable {
  final String id;
  final String reviewerId;
  final double rating;
  final String? review;
  @PictureSerializer()
  final List<Picture> pictures;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.reviewerId,
    required this.rating,
    this.review,
    required this.pictures,
    required this.createdAt,
  });

  Review.create({
    required this.reviewerId,
    required this.rating,
    this.review,
  })  : id = uuid.v1(),
        pictures = [],
        createdAt = DateTime.now();
}

class ReviewSerializer extends Serializer<Review> {
  const ReviewSerializer();
  Review fromJson(Json json) => _$ReviewFromJson(json);
  Json toJson(Review data) => _$ReviewToJson(data);
}
