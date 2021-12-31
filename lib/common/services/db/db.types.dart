part of db;

// typedef T FromMapFunction<T extends Serializable>(Map map);

abstract class Serializable {
  String get id;
}

abstract class Serializer<T extends Serializable>
    extends JsonConverter<T, Map<String, dynamic>> {
  const Serializer();
  Map<String, dynamic> toJson(T data);
  T fromJson(Map<String, dynamic> json);
}

abstract class Client<T extends Serializable> {
  Future<List<T>> getAll();
  Future<T?> get(String id);
  Future<T> update(String id, Map overrides);
  Future<void> create(T data);
  Future<void> delete(String id);
  Stream<T?> watch({String? id});
}

abstract class Db {
  Future<void> init();
  Future<void> close();
  Client<RecipeMeta> get recipeMeta;
  Client<RecipeIteration> get recipeIteration;
  Client<RecipeIngredient> get recipeIngredient;
  Client<RecipeStep> get recipeStep;
  Client<RecipeReview> get recipeReview;
}

enum DbProvider { hive, firebase, mock }
