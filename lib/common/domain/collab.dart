import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/collab.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Collab extends Serializable {
  final String id;
  final String ownerId;
  final String recipeId;
  final List<String>? iterationIds;
  final UserRole role;

  Collab({
    required this.id,
    required this.ownerId,
    required this.recipeId,
    this.iterationIds,
    required this.role,
  });

  Collab.create({
    required this.ownerId,
    required this.recipeId,
    required this.role,
  })  : id = uuid.v1(),
        iterationIds = [];
}

class CollabSerializer extends Serializer<Collab> {
  const CollabSerializer();
  Collab fromJson(Json json) => _$CollabFromJson(json);
  Json toJson(Collab data) => _$CollabToJson(data);
}

enum UserRole { editor, reader, reviewer }
