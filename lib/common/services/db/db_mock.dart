part of db;

class MockClient<T extends Serializable> extends Client<T> {
  Map<String, T> db = Map();
  Duration mockDelay = Duration(milliseconds: 100);
  late final Serializer<T> serializer;

  void init({required Serializer<T> serializer}) {
    this.serializer = serializer;
  }

  Future<void> create(T data) {
    db[data.id] = data;
    return Future.delayed(mockDelay);
  }

  Future<void> deleteAll() async {
    db.clear();
    return Future.delayed(mockDelay);
  }

  Future<void> delete(String id) {
    db.removeWhere((key, _) => key == id);
    return Future.delayed(mockDelay);
  }

  Future<T?> get(String id) {
    final data = db[id];
    return Future.delayed(mockDelay, () => data);
  }

  Future<List<T>> getAll() {
    final data = db.values.toList();
    return Future.delayed(mockDelay, () => data);
  }

  Future<void> update(T data) {
    db.update(data.id, (_) => data);
    return Future.delayed(mockDelay, () {});
  }

  SubscriptionCancel watchAll(
    SubscriptionOnData<List<T>> onData,
    SubscriptionOnError onError,
  ) {
    // TODO: implement watchAll
    throw UnimplementedError();
  }

  SubscriptionCancel watch(
    String id,
    SubscriptionOnData<T> onData,
    SubscriptionOnError onError,
  ) {
    // TODO: implement watch
    throw UnimplementedError();
  }
}

class MockDb extends Db {
  MockClient<T> _build<T extends Serializable>(
    Serializer<T> serializer,
  ) {
    return MockClient<T>()..init(serializer: serializer);
  }

  Future<void> init() async {}
  Future<void> close() async {}

  MockClient<UserMeta> get userMeta => _build(
        UserMetaSerializer(),
      );
  MockClient<RecipeMeta> recipeMeta({String? userId}) => _build(
        RecipeMetaSerializer(),
      );
  MockClient<RecipeIteration> recipeIteration(
    String recipeId, {
    String? userId,
  }) =>
      _build(
        RecipeIterationSerializer(),
      );
  MockClient<RecipeReview> recipeReview({String? userId}) => _build(
        RecipeReviewSerializer(),
      );
}
