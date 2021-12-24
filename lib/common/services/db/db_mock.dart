part of db;

class MockClient<T extends Serializable> extends Client<T> {
  Map<String, T> db = Map();
  Duration mockDelay = Duration(milliseconds: 100);
  late FromMapFunction<T> fromMap;

  void init({required FromMapFunction<T> fromMap}) {
    this.fromMap = fromMap;
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

  Future<T> update(String id, Map overrides) {
    final newData = db.update(id, (oldData) {
      final newDataAsMap = {...oldData.toMap(), ...overrides};
      return fromMap(newDataAsMap);
    });
    return Future.delayed(mockDelay, () => newData);
  }

  Stream<T> watch({String? id}) {
    final data = db[id];
    if (data == null) throw Exception('Cannot watch non-existent data');

    return Stream.value(data);
  }
}

class MockDb extends Db {
  MockClient<T> _build<T extends Serializable>(
    FromMapFunction<T> fromMap,
  ) {
    return MockClient<T>()..init(fromMap: fromMap);
  }

  Future<void> init() async {}
  Future<void> close() async {}

  MockClient<Recipe> get recipe => _build(
        Recipe.fromMap,
      );
  MockClient<RecipeIteration> get recipeIteration => _build(
        RecipeIteration.fromMap,
      );
  MockClient<RecipeIngredient> get recipeIngredient => _build(
        RecipeIngredient.fromMap,
      );
  MockClient<RecipeStep> get recipeStep => _build(
        RecipeStep.fromMap,
      );
  MockClient<RecipeReview> get recipeReview => _build(
        RecipeReview.fromMap,
      );
}
