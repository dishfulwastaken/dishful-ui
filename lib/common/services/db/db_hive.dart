part of db;

class _HiveBoxName {
  static const _base = 'dishful_hive_storage';
  static const userMeta = '${_base}_user_meta';
  static const recipeMeta = '${_base}_recipe_meta';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeReview = '${_base}_recipe_review';
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

  Future<List<T>> getAll() async {
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

  Future<void> deleteAll() async {
    assert(box != null, 'HiveClient.init must be called first!');
    await box!.clear();
  }

  Future<void> delete(String id) async {
    assert(box != null, 'HiveClient.init must be called first!');
    await box!.delete(id);
  }

  SubscriptionCancel watchAll(
    SubscriptionOnData<List<T>> onData,
    SubscriptionOnError onError,
  ) {
    assert(box != null, 'HiveClient.init must be called first!');
    final rawStream = box!.watch();
    final serializedStream = rawStream.map(
      (event) =>
          (box!.values).map(jsonifyMap).map(serializer.fromJson).toList(),
    );
    final subscription = serializedStream.listen(
      (data) {
        onData(data);
      },
    );

    return subscription.cancel;
  }

  SubscriptionCancel watch(
    String id,
    SubscriptionOnData<T> onData,
    SubscriptionOnError onError,
  ) {
    assert(box != null, 'HiveClient.init must be called first!');
    final rawStream = box!.watch(key: id);
    final serializedStream = rawStream.map<T?>(
      (event) =>
          event.deleted ? null : serializer.fromJson(jsonifyMap(event.value)),
    );
    final subscription = serializedStream.listen(
      (nullableData) {
        if (nullableData == null) return;
        onData(nullableData);
      },
    );

    return subscription.cancel;
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

  HiveClient<UserMeta>? _userMeta;
  HiveClient<RecipeMeta>? _recipeMeta;
  HiveClient<RecipeIteration>? _recipeIteration;
  HiveClient<RecipeReview>? _recipeReview;

  Future<void> init() async {
    await Hive.initFlutter();

    _userMeta = await _buildClient(
      _HiveBoxName.userMeta,
      UserMetaSerializer(),
    );
    _recipeMeta = await _buildClient(
      _HiveBoxName.recipeMeta,
      RecipeMetaSerializer(),
    );
    _recipeIteration = await _buildClient(
      _HiveBoxName.recipeIteration,
      RecipeIterationSerializer(),
    );
    _recipeReview = await _buildClient(
      _HiveBoxName.recipeReview,
      RecipeReviewSerializer(),
    );
  }

  Future<void> close() async {
    await Hive.close();
  }

  HiveClient<UserMeta> get userMeta => _userMeta!;
  HiveClient<RecipeMeta> recipeMeta({String? userId}) => _recipeMeta!;
  HiveClient<RecipeIteration> recipeIteration(
    String recipeId, {
    String? userId,
  }) =>
      _recipeIteration!;
  HiveClient<RecipeReview> recipeReview({String? userId}) => _recipeReview!;
}
