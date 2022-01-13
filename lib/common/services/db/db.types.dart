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

typedef SubscriptionCancel = Future<void> Function();
typedef SubscriptionOnData<T> = void Function(T);
typedef SubscriptionOnError<T> = void Function(T);

typedef SubcollectionDeleter = Future<void> Function({dynamic arg});

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

  /// Delete all documents in the collection.
  Future<void> deleteAll();

  /// Delete a document with ID = [id].
  Future<void> delete(String id);

  /// Subscribe to changes to the entire collection.
  /// Returns a function that *must* be called that will
  /// cancel the subscription.
  SubscriptionCancel watchAll(
    SubscriptionOnData<List<T>> onData,
    SubscriptionOnError onError,
  );

  /// Subscribe to change to a document with ID = [id].
  /// Returns a function that *must* be called that will
  /// cancel the subscription.
  SubscriptionCancel watch(
    String id,
    SubscriptionOnData<T> onData,
    SubscriptionOnError onError,
  );
}

abstract class Db {
  Future<void> init();
  Future<void> close();
  Client<UserMeta> get userMeta;
  Client<RecipeMeta> recipeMeta({String userId});
  Client<RecipeIteration> recipeIteration(String recipeId, {String userId});
  Client<RecipeReview> recipeReview({String userId});
}

enum DbProvider { hive, firebase, mock }
