part of db;

class _HiveBoxName {
  static const _base = 'dishful_hive_storage';
  static const subscribers = '${_base}_user_meta';
  static const recipes = '${_base}_recipes_meta';
  static const iterations = '${_base}_recipes_iteration';
  static const collabs = '${_base}_collabs';
}

class HiveClient<T extends Serializable> extends Client<T> {
  Box<Map>? box;
  late final Serializer<T> serializer;

  Future<void> init({
    required String boxName,
    required Serializer<T> serializer,
  }) async {
    this.serializer = serializer;
    bool notOpen = !Hive.isBoxOpen(boxName);

    box = notOpen ? await Hive.openBox(boxName) : Hive.box(boxName);
  }

  Future<List<T>> getAll({Map<String, String>? filters}) async {
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

  Future<void> deleteAll({Map<String, String>? filters}) async {
    assert(box != null, 'HiveClient.init must be called first!');
    await box!.clear();
  }

  Future<void> delete(String id) async {
    assert(box != null, 'HiveClient.init must be called first!');
    await box!.delete(id);
  }

  Stream<List<T>> watchAll({Map<String, String>? filters}) {
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

class HiveDb extends Db {
  Future<HiveClient<T>> _buildClient<T extends Serializable>(
    String boxName,
    Serializer<T> serializer,
  ) async {
    final client = HiveClient<T>();
    await client.init(boxName: boxName, serializer: serializer);
    return client;
  }

  HiveClient<Subscriber>? _subscribers;
  HiveClient<Recipe>? _recipes;
  HiveClient<Iteration>? _iterations;
  HiveClient<Collab>? _collabs;

  Future<void> init() async {
    await Hive.initFlutter();

    _subscribers = await _buildClient(
      _HiveBoxName.subscribers,
      SubscriberSerializer(),
    );
    _recipes = await _buildClient(
      _HiveBoxName.recipes,
      RecipeSerializer(),
    );
    _iterations = await _buildClient(
      _HiveBoxName.iterations,
      IterationSerializer(),
    );
    _collabs = await _buildClient(
      _HiveBoxName.collabs,
      CollabSerializer(),
    );
  }

  Future<void> close() async {
    await Hive.close();
  }

  HiveClient<Subscriber> get subscribers => _subscribers!;
  HiveClient<Recipe> get recipes => _recipes!;
  HiveClient<Collab> get collabs => _collabs!;
  HiveClient<Iteration> iterations(String recipeId) => _iterations!;
}
