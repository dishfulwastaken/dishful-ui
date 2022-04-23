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

  Future<void> deleteAll({List<Filter>? filters}) async {
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

  Future<List<T>> getAll({List<Filter>? filters}) {
    final data = db.values.toList();
    return Future.delayed(mockDelay, () => data);
  }

  Future<void> update(T data) {
    db.update(data.id, (_) => data);
    return Future.delayed(mockDelay, () {});
  }

  Stream<List<T>> watchAll({List<Filter>? filters}) {
    throw UnimplementedError();
  }

  Stream<T?> watch(String id) {
    throw UnimplementedError();
  }

  @override
  // TODO: implement filterAdapter
  FilterAdapter get filterAdapter => throw UnimplementedError();
}

class MockDb extends Db {
  MockClient<T> _build<T extends Serializable>(
    Serializer<T> serializer,
  ) {
    return MockClient<T>()..init(serializer: serializer);
  }

  Future<void> init() async {}
  Future<void> close() async {}

  MockClient<Subscription> get userMeta => _build(
        SubscriptionSerializer(),
      );
  MockClient<Recipe> recipeMeta({String? userId}) => _build(
        RecipeSerializer(),
      );
  MockClient<Iteration> recipeIteration(
    String recipeId, {
    String? userId,
  }) =>
      _build(
        IterationSerializer(),
      );
  MockClient<Review> recipeReview(
    String recipeId,
    String iterationId, {
    String? userId,
  }) =>
      _build(
        ReviewSerializer(),
      );

  @override
  Client<Iteration> iterations(String recipeId) {
    // TODO: implement iterations
    throw UnimplementedError();
  }

  @override
  // TODO: implement recipes
  Client<Recipe> get recipes => throw UnimplementedError();

  @override
  // TODO: implement subscriptions
  Client<Subscription> get subscriptions => throw UnimplementedError();
}
