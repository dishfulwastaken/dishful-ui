import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'generated/user_meta.g.dart';

final uuid = Uuid();

@JsonSerializable()
class UserMeta extends Serializable {
  final String id;
  final DateTime? subscribedUntil;

  UserMeta({
    required this.id,
    this.subscribedUntil,
  });

  UserMeta.create({
    this.subscribedUntil,
  }) : id = uuid.v1();
}

class UserMetaSerializer extends Serializer<UserMeta> {
  const UserMetaSerializer();
  UserMeta fromJson(Map<String, dynamic> json) => _$UserMetaFromJson(json);
  Map<String, dynamic> toJson(UserMeta data) => _$UserMetaToJson(data);
}
