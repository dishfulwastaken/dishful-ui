part of db;

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
  /// Get all documents in the collection.
  Future<List<T>> getAll();

  /// Get a document with ID = [id].
  Future<T?> get(String id);

  /// Update the document with ID = [data.id],
  /// setting the content to [data].
  Future<void> update(T data);

  /// Create a new document with ID = [data.id],
  /// setting the content to [data]. This
  /// will create a collection if it does not
  /// exist.
  Future<void> create(T data);

  /// Delete a document with ID = [id].
  Future<void> delete(String id);

  /// TODO: define this!
  Stream<T?> watch({String? id});
}

abstract class Db {
  Future<void> init();
  Future<void> close();
  Client<RecipeMeta> get recipeMeta;
  Client<RecipeIteration> recipeIteration(String recipeId);
  Client<RecipeReview> get recipeReview;
}

enum DbProvider { hive, firebase, mock }
