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

  Stream<T> watch({String? id}) {
    final data = db[id];
    if (data == null) throw Exception('Cannot watch non-existent data');

    return Stream.value(data);
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

  MockClient<RecipeMeta> get recipeMeta => _build(
        RecipeMetaSerializer(),
      );
  MockClient<RecipeIteration> recipeIteration(String recipeId) => _build(
        RecipeIterationSerializer(),
      );
  MockClient<RecipeIngredient> get recipeIngredient => _build(
        RecipeIngredientSerializer(),
      );
  MockClient<RecipeStep> get recipeStep => _build(
        RecipeStepSerializer(),
      );
  MockClient<RecipeReview> get recipeReview => _build(
        RecipeReviewSerializer(),
      );
}
