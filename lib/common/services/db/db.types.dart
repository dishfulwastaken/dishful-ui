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

class Filter {
  final Object field;
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final bool? isNull;
  // TODO: support the following filters as needed.
  // final Object? isLessThan;
  // final Object? isLessThanOrEqualTo;
  // final Object? isGreaterThan;
  // final Object? isGreaterThanOrEqualTo;
  // final Object? arrayContains;
  // final List<Object?>? arrayContainsAny;
  // final List<Object?>? whereIn;
  // final List<Object?>? whereNotIn;

  Filter({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isNull,
    // this.isLessThan,
    // this.isLessThanOrEqualTo,
    // this.isGreaterThan,
    // this.isGreaterThanOrEqualTo,
    // this.arrayContains,
    // this.arrayContainsAny,
    // this.whereIn,
    // this.whereNotIn,
  });
}

abstract class FilterAdapter<T, U> {
  /// [T] is what will be returned after applying the filters.
  /// [U] is a object specific to the DB that the filters will be applied to.
  T applyFilters(List<Filter> filters, U container);
}

abstract class Client<T extends Serializable> {
  abstract final FilterAdapter filterAdapter;

  /// Get all documents in the collection.
  Future<List<T>> getAll({List<Filter>? filters});

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
  Future<void> deleteAll({List<Filter>? filters});

  /// Delete a document with ID = [id].
  Future<void> delete(String id);

  /// Streams all documents in the collection.
  Stream<List<T>> watchAll({List<Filter>? filters});

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
