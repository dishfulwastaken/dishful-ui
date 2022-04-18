part of db;

typedef Json = Map<String, dynamic>;

abstract class Serializable {
  String get id;
}

abstract class Serializer<T extends Serializable?>
    extends JsonConverter<T, Json> {
  const Serializer();
  Json toJson(T data);
  T fromJson(Json json);
}

typedef OnCreateHook<T> = Future<void> Function(T data);
typedef OnReadHook<T> = Future<void> Function(T data);
typedef OnUpdateHook<T> = Future<void> Function(T data);
typedef OnDeleteHook = Future<void> Function(String id);

abstract class Client<T extends Serializable> {
  /// Get all documents in the collection.
  Future<List<T>> getAll({Map<String, String>? filters});

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

  /// Delete all documents in the collection.
  Future<void> deleteAll({Map<String, String>? filters});

  /// Delete a document with ID = [id].
  Future<void> delete(String id);

  /// Streams all documents in the collection.
  Stream<List<T>> watchAll({Map<String, String>? filters});

  /// Streams a document with ID = [id]
  Stream<T?> watch(String id);
}

abstract class Db {
  Future<void> init();
  Future<void> close();
  Client<Subscription> get subscriptions;
  Client<Recipe> get recipes;
  Client<Iteration> iterations(String recipeId);

  String buildPath(Iterable<String> paths) {
    return paths.intersperse("/").join();
  }
}

enum DbProvider { hive, firebase, mock }
