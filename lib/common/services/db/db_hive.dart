part of db;

class _HiveBoxName {
  static const _base = 'dishful_hive_storage';
  static const recipe = '${_base}_recipe';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeIngredient = '${_base}_recipe_ingredient';
  static const recipeStep = '${_base}_recipe_step';
  static const recipeReview = '${_base}_recipe_review';
}

Future<void> setUpHiveDb() async {
  await Hive.initFlutter();
}

void closeHiveDb() async {
  await Hive.close();
}

class HiveClient<T extends Serializable> extends Client<T> {
  Box<Map<String, dynamic>>? box;
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

  Future<T> update(String id, Map<String, dynamic> overrides) async {
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

  Stream<T> watch({String? id}) {
    assert(box != null, 'HiveClient.init must be called first!');
    final rawStream = box!.watch(key: id);
    return rawStream.asyncMap<T>((event) {
      return fromMap(event.value);
    });
  }
}

class HiveDb extends Db {
  HiveClient<T> _build<T extends Serializable>(
    String boxName,
    FromMapFunction<T> fromMap,
  ) {
    return HiveClient<T>()..init(boxName: boxName, fromMap: fromMap);
  }

  HiveClient<Recipe> get recipe => _build(
        _HiveBoxName.recipe,
        Recipe.fromMap,
      );
  HiveClient<RecipeIteration> get recipeIteration => _build(
        _HiveBoxName.recipeIteration,
        RecipeIteration.fromMap,
      );
  HiveClient<RecipeIngredient> get recipeIngredient => _build(
        _HiveBoxName.recipeIngredient,
        RecipeIngredient.fromMap,
      );
  HiveClient<RecipeStep> get recipeStep => _build(
        _HiveBoxName.recipeStep,
        RecipeStep.fromMap,
      );
  HiveClient<RecipeReview> get recipeReview => _build(
        _HiveBoxName.recipeReview,
        RecipeReview.fromMap,
      );
}
