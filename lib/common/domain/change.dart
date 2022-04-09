import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/change.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Change extends Serializable {
  final String id;
  final ChangeType type;

  Change({
    required this.id,
    required this.type,
  });

  Change.create({
    required this.type,
  }) : id = uuid.v1();
}

class ChangeSerializer extends Serializer<Change> {
  const ChangeSerializer();
  Change fromJson(Json json) => _$ChangeFromJson(json);
  Json toJson(Change data) => _$ChangeToJson(data);
}

enum ChangeType { create, update, delete }
