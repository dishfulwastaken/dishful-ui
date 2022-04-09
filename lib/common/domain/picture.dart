import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:uuid/uuid.dart';

part 'generated/picture.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Picture extends Serializable {
  final String id;
  final bool isLocal;
  late final String path;
  final String blurHash;
  final int width;
  final int height;

  Picture({
    required this.id,
    required this.isLocal,
    required this.blurHash,
    required this.width,
    required this.height,
  });

  Picture.create({
    String? id,
    required this.blurHash,
    required this.width,
    required this.height,
    this.isLocal = false,
  }) : id = id ?? uuid.v1();

  Picture copyWithPath(String path) => copyWith()..path = path;
}

class PictureSerializer extends Serializer<Picture> {
  const PictureSerializer();
  Picture fromJson(Json json) => _$PictureFromJson(json);
  Json toJson(Picture data) => _$PictureToJson(data);
}
