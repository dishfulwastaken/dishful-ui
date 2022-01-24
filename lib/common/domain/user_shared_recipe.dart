import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/user_shared_recipe.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class UserSharedRecipe extends Serializable {
  final String id;
  final String ownerId;
  final String recipeId;
  final List<String>? iterationIds;
  final UserRole role;

  UserSharedRecipe({
    required this.id,
    required this.ownerId,
    required this.recipeId,
    this.iterationIds,
    required this.role,
  });

  UserSharedRecipe.create({
    required this.ownerId,
    required this.recipeId,
    required this.role,
  })  : id = uuid.v1(),
        iterationIds = [];
}

class UserSharedRecipeSerializer extends Serializer<UserSharedRecipe> {
  const UserSharedRecipeSerializer();
  UserSharedRecipe fromJson(Json json) => _$UserSharedRecipeFromJson(json);
  Json toJson(UserSharedRecipe data) => _$UserSharedRecipeToJson(data);
}

enum UserRole { editor, reader, reviewer }
