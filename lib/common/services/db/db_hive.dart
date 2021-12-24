part of db;

class _HiveBoxName {
  static const _base = 'dishful_hive_storage';
  static const recipe = '${_base}_recipe';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeIngredient = '${_base}_recipe_ingredient';
  static const recipeStep = '${_base}_recipe_step';
  static const recipeReview = '${_base}_recipe_review';
}

class HiveClient<T extends Serializable> extends Client<T> {
  Box<Map>? box;
  late FromMapFunction<T> fromMap;

  Future<void> init({
    required String boxName,
    required FromMapFunction<T> fromMap,
  }) async {
    this.fromMap = fromMap;
    bool notOpen = !Hive.isBoxOpen(boxName);

    box = notOpen ? await Hive.openBox(boxName) : Hive.box(boxName);
  }

  Future<List<T>> getAll() async {
    assert(box != null, 'HiveClient.init must be called first!');
    final data = box!.values.map(fromMap);
    return data.toList();
  }

  Future<T?> get(String id) async {
    assert(box != null, 'HiveClient.init must be called first!');
    final dataAsMap = box!.get(id);
    return dataAsMap == null ? null : fromMap(dataAsMap);
  }

  Future<void> create(T data) async {
    assert(box != null, 'HiveClient.init must be called first!');
    final dataAsMap = data.toMap();
    box!.put(data.id, dataAsMap);
  }

  Future<T> update(String id, Map overrides) async {
    assert(box != null, 'HiveClient.init must be called first!');
    final oldDataAsMap = box!.get(id);
    final newDataAsMap = {...oldDataAsMap ?? {}, ...overrides};
    box!.put(id, newDataAsMap);
    return fromMap(newDataAsMap);
  }

  Future<void> delete(String id) async {
    assert(box != null, 'HiveClient.init must be called first!');
    box!.delete(id);
  }

  Stream<T?> watch({String? id}) {
    assert(box != null, 'HiveClient.init must be called first!');
    final rawStream = box!.watch(key: id);
    final serializedStream = rawStream.map<T?>(
      (event) => event.deleted ? null : fromMap(event.value),
    );
    return serializedStream;
  }
}

class HiveDb extends Db {
  Future<HiveClient<T>> _buildClient<T extends Serializable>(
    String boxName,
    FromMapFunction<T> fromMap,
  ) async {
    final client = HiveClient<T>();
    await client.init(boxName: boxName, fromMap: fromMap);
    return client;
  }

  HiveClient<Recipe>? _recipe;
  HiveClient<RecipeIteration>? _recipeIteration;
  HiveClient<RecipeIngredient>? _recipeIngredient;
  HiveClient<RecipeStep>? _recipeStep;
  HiveClient<RecipeReview>? _recipeReview;

  Future<void> init() async {
    await Hive.initFlutter();

    _recipe = await _buildClient(
      _HiveBoxName.recipe,
      Recipe.fromMap,
    );
    _recipeIteration = await _buildClient(
      _HiveBoxName.recipeIteration,
      RecipeIteration.fromMap,
    );
    _recipeIngredient = await _buildClient(
      _HiveBoxName.recipeIngredient,
      RecipeIngredient.fromMap,
    );
    _recipeStep = await _buildClient(
      _HiveBoxName.recipeStep,
      RecipeStep.fromMap,
    );
    _recipeReview = await _buildClient(
      _HiveBoxName.recipeReview,
      RecipeReview.fromMap,
    );
  }

  Future<void> close() async {
    await Hive.close();
  }

  HiveClient<Recipe> get recipe {
    assert(_recipe != null, 'HiveDb.init must be called first!');
    return _recipe!;
  }

  HiveClient<RecipeIteration> get recipeIteration {
    assert(_recipeIteration != null, 'HiveDb.init must be called first!');
    return _recipeIteration!;
  }

  HiveClient<RecipeIngredient> get recipeIngredient {
    assert(_recipeIngredient != null, 'HiveDb.init must be called first!');
    return _recipeIngredient!;
  }

  HiveClient<RecipeStep> get recipeStep {
    assert(_recipeStep != null, 'HiveDb.init must be called first!');
    return _recipeStep!;
  }

  HiveClient<RecipeReview> get recipeReview {
    assert(_recipeReview != null, 'HiveDb.init must be called first!');
    return _recipeReview!;
  }
}
