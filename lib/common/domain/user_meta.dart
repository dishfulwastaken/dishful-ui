import 'package:dishful/common/data/datetime.dart';
import 'package:dishful/common/domain/user_shared_recipe.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/user_meta.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class UserMeta extends Serializable {
  final String id;
  final DateTime? subscribedUntil;
  @UserSharedRecipeSerializer()
  final List<UserSharedRecipe> sharedWithMe;

  bool get isPro {
    if (subscribedUntil == null) return false;

    return subscribedUntil!.isAfterNow;
  }

  UserMeta({
    required this.id,
    required this.sharedWithMe,
    this.subscribedUntil,
  });

  UserMeta.create({
    String? id,
    this.subscribedUntil,
  })  : id = id ?? uuid.v1(),
        sharedWithMe = [];
}

class UserMetaSerializer extends Serializer<UserMeta> {
  const UserMetaSerializer();
  UserMeta fromJson(Json json) => _$UserMetaFromJson(json);
  Json toJson(UserMeta data) => _$UserMetaToJson(data);
}
