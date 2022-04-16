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

  Future<void> deleteAll({Map<String, String>? filters}) async {
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

  Future<List<T>> getAll({Map<String, String>? filters}) {
    final data = db.values.toList();
    return Future.delayed(mockDelay, () => data);
  }

  Future<void> update(T data) {
    db.update(data.id, (_) => data);
    return Future.delayed(mockDelay, () {});
  }

  Stream<List<T>> watchAll({Map<String, String>? filters}) {
    throw UnimplementedError();
  }

  Stream<T?> watch(String id) {
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

  MockClient<Subscriber> get userMeta => _build(
        SubscriberSerializer(),
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
  // TODO: implement collabs
  Client<Collab> get collabs => throw UnimplementedError();

  @override
  Client<Iteration> iterations(String recipeId) {
    // TODO: implement iterations
    throw UnimplementedError();
  }

  @override
  // TODO: implement recipes
  Client<Recipe> get recipes => throw UnimplementedError();

  @override
  // TODO: implement subscribers
  Client<Subscriber> get subscribers => throw UnimplementedError();
}
