import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'generated/user_shared_recipe.g.dart';

final uuid = Uuid();

@JsonSerializable()
class UserSharedRecipe extends Serializable {
  final String id;
  final String ownerId;
  final String recipeId;
  final UserRole role;
  final DateTime? sharedUntil;

  UserSharedRecipe({
    required this.id,
    required this.ownerId,
    required this.recipeId,
    required this.role,
    this.sharedUntil,
  });

  UserSharedRecipe.create({
    required this.ownerId,
    required this.recipeId,
    required this.role,
    this.sharedUntil,
  }) : id = uuid.v1();
}

class UserSharedRecipeSerializer extends Serializer<UserSharedRecipe> {
  const UserSharedRecipeSerializer();
  UserSharedRecipe fromJson(Map<String, dynamic> json) =>
      _$UserSharedRecipeFromJson(json);
  Map<String, dynamic> toJson(UserSharedRecipe data) =>
      _$UserSharedRecipeToJson(data);
}

enum UserRole { owner, editor, reader }
