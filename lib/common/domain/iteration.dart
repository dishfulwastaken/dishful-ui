import 'package:dishful/common/domain/change.dart';
import 'package:dishful/common/domain/review.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/iteration.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Iteration extends Serializable {
  final String id;
  final String? parentId;
  final String? title;
  @ReviewSerializer()
  final List<Review> reviews;
  @ChangeSerializer()
  final List<Change> changes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Iteration({
    required this.id,
    this.parentId,
    this.title,
    required this.reviews,
    required this.changes,
    required this.createdAt,
    required this.updatedAt,
  });

  Iteration.create({
    this.parentId,
    this.title,
    required this.changes,
  })  : id = uuid.v1(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        reviews = [];
}

class IterationSerializer extends Serializer<Iteration> {
  const IterationSerializer();
  Iteration fromJson(Json json) => _$IterationFromJson(json);
  Json toJson(Iteration data) => _$IterationToJson(data);
}
