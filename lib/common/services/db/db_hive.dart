part of db;

class _HiveBoxName {
  static const _base = 'dishful_hive_db';
  static const subscriptions = '${_base}_subscriptions';
  static const recipes = '${_base}_recipes';
  static const iterations = '${_base}_iterations';
}

class HiveFilterAdapter<T extends Serializable, U extends Box>
    extends FilterAdapter<List<T>, U> {
  @override
  List<T> applyFilters(List<Filter> filters, U container) {
    return container.get('');
  }
}

class HiveClient<T extends Serializable> extends Client<T> {
  Box<Map>? box;
  late final Serializer<T> serializer;
  final FilterAdapter<List<T>, Box> filterAdapter;

  HiveClient({required this.filterAdapter});

  Future<void> init({
    required String boxName,
    required Serializer<T> serializer,
  }) async {
    this.serializer = serializer;
    bool notOpen = !Hive.isBoxOpen(boxName);

    box = notOpen ? await Hive.openBox(boxName) : Hive.box(boxName);
  }

  Future<List<T>> getAll({List<Filter>? filters}) async {
    assert(box != null, 'HiveClient.init must be called first!');
    final data = (box!.values).map(jsonifyMap).map(serializer.fromJson);
    return data.toList();
  }

  Future<T?> get(String id) async {
    assert(box != null, 'HiveClient.init must be called first!');
    final dataAsMap = box!.get(id);
    return dataAsMap == null
        ? null
        : serializer.fromJson(jsonifyMap(dataAsMap));
  }

  Future<void> create(T data) async {
    assert(box != null, 'HiveClient.init must be called first!');
    final dataAsMap = serializer.toJson(data).cast<dynamic, dynamic>();
    await box!.put(data.id, dataAsMap);
  }

  Future<void> update(T data) async {
    assert(box != null, 'HiveClient.init must be called first!');
    await box!.put(data.id, serializer.toJson(data));
  }

  Future<void> deleteAll({List<Filter>? filters}) async {
    assert(box != null, 'HiveClient.init must be called first!');
    await box!.clear();
  }

  Future<void> delete(String id) async {
    assert(box != null, 'HiveClient.init must be called first!');
    await box!.delete(id);
  }

  Stream<List<T>> watchAll({List<Filter>? filters}) {
    assert(box != null, 'HiveClient.init must be called first!');
    final rawStream = box!.watch();
    final serializedStream = rawStream.map(
      (event) =>
          (box!.values).map(jsonifyMap).map(serializer.fromJson).toList(),
    );

    return serializedStream;
  }

  Stream<T?> watch(String id) {
    assert(box != null, 'HiveClient.init must be called first!');
    final rawStream = box!.watch(key: id);
    final serializedStream = rawStream.map<T?>(
      (event) =>
          event.deleted ? null : serializer.fromJson(jsonifyMap(event.value)),
    );

    return serializedStream;
  }
}

class HiveDb extends PrivateDb {
  Future<HiveClient<T>> _buildClient<T extends Serializable>(
    String boxName,
    Serializer<T> serializer,
  ) async {
    final client = HiveClient<T>(filterAdapter: HiveFilterAdapter());
    await client.init(boxName: boxName, serializer: serializer);
    return client;
  }

  HiveClient<Recipe>? _recipes;
  HiveClient<Iteration>? _iterations;

  Future<void> init() async {
    await Hive.initFlutter();

    _recipes = await _buildClient(
      _HiveBoxName.recipes,
      RecipeSerializer(),
    );
    _iterations = await _buildClient(
      _HiveBoxName.iterations,
      IterationSerializer(),
    );
  }

  Future<void> close() async {
    await Hive.close();
  }

  HiveClient<Recipe> get recipes => _recipes!;
  HiveClient<Iteration> iterations(String recipeId) => _iterations!;
}
