part of db;

class _FirestoreCollectionName {
  static const _base = 'dishful_firestore_db';
  static const subscriptions = '${_base}_subscriptions';
  static const recipes = '${_base}_recipes';
  static const iterations = '${_base}_iterations';
}

class FirestoreFilterAdapter<T extends Serializable,
    U extends CollectionReference<T?>> extends FilterAdapter<Query<T?>, U> {
  @override
  Query<T?> applyFilters(List<Filter> filters, U container) {
    final query = filters.fold<Query<T?>>(
      container,
      (previousValue, filter) => previousValue.where(
        filter.field,
        isEqualTo: filter.isEqualTo,
        isNotEqualTo: filter.isNotEqualTo,
        isNull: filter.isNull,
      ),
    );

    return query;
  }
}

class FirestoreClient<T extends Serializable> extends Client<T> {
  final OnCreateHook<T>? onCreate;
  final OnReadHook<T>? onRead;
  final OnUpdateHook<T>? onUpdate;
  final OnDeleteHook? onDelete;
  late final CollectionReference<T?> _collection;
  final FilterAdapter<Query<T?>, CollectionReference<T?>> filterAdapter;

  FirestoreClient(
    String collectionPath,
    Serializer<T> serializer, {
    required this.filterAdapter,
    this.onCreate,
    this.onRead,
    this.onUpdate,
    this.onDelete,
  }) {
    _collection =
        FirebaseFirestore.instance.collection(collectionPath).withConverter(
      fromFirestore: (doc, _) {
        final json = doc.data();
        if (json == null) return null;

        return serializer.fromJson(json);
      },
      toFirestore: (data, _) {
        if (data == null) return {};

        return serializer.toJson(data);
      },
    );
  }

  List<T> extractNonNullData<T>(List<QueryDocumentSnapshot<T?>> docs) {
    return docs.fold([], (previousValue, element) {
      if (element.exists) previousValue.add(element.data()!);

      return previousValue;
    });
  }

  Future<void> create(T data) async {
    await onCreate?.call(data);
    await _collection.doc(data.id).set(data);
  }

  Future<void> delete(String id) async {
    await onDelete?.call(id);
    await _collection.doc(id).delete();
  }

  Future<void> deleteAll({List<Filter>? filters}) async {
    final query = filters == null
        ? _collection
        : filterAdapter.applyFilters(filters, _collection);

    final docs = (await query.get()).docs;
    docs.forEach((element) async {
      await onDelete?.call(element.id);
      element.reference.delete();
    });
  }

  Future<T?> get(String id) async {
    final doc = await _collection.doc(id).get();
    final data = doc.data();
    if (data != null) await onRead?.call(data);

    return data;
  }

  Future<List<T>> getAll({List<Filter>? filters}) async {
    /// Some queries!
    ///
    // final userId = AuthService.currentUser!.uid;
    // final allRecipesIHaveAccessTo =
    //     _collection.where('roles.$userId', isNull: false);
    // final allRecipesIOwn =
    //     _collection.where('roles.$userId', isEqualTo: Role.owner);
    // final allRecipesSharedWithMe =
    //     _collection.where('roles.$userId', isNotEqualTo: Role.owner);
    // final allRecipesIOwnThatAreNotShared =
    //     _collection.where('roles', isEqualTo: {userId: Role.owner});

    final query = filters == null
        ? _collection
        : filterAdapter.applyFilters(filters, _collection);

    final docs = (await query.get()).docs;
    final data = extractNonNullData(docs).toList();
    data.forEach((item) async => await onRead?.call(item));

    return data;
  }

  Future<void> update(T data) async {
    await onUpdate?.call(data);
    await _collection.doc(data.id).set(data);
  }

  Stream<List<T>> watchAll({List<Filter>? filters}) {
    final query = filters == null
        ? _collection
        : filterAdapter.applyFilters(filters, _collection);
    final stream = query
        .snapshots()
        .map((querySnapshot) => extractNonNullData(querySnapshot.docs));

    return stream;
  }

  Stream<T?> watch(String id) {
    final stream = _collection
        .doc(id)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.data());

    return stream;
  }
}

class FirestoreDb extends Db {
  Future<void> init() async {
    assert(CloudService.ready, "CloudService.init must be called first!");

    if (Env.isMock)
      FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
  }

  Future<void> close() async {}

  FirestoreClient<Subscription> get subscriptions {
    final collectionPath = _FirestoreCollectionName.subscriptions;

    return FirestoreClient<Subscription>(
      collectionPath,
      SubscriptionSerializer(),
      filterAdapter: FirestoreFilterAdapter(),
      onDelete: (userId) async {
        await recipes.deleteAll();
      },
    );
  }

  FirestoreClient<Recipe> get recipes {
    final collectionPath = _FirestoreCollectionName.recipes;

    return FirestoreClient<Recipe>(
      collectionPath,
      RecipeSerializer(),
      filterAdapter: FirestoreFilterAdapter(),
      onDelete: (recipeId) async {
        final pictures = (await recipes.get(recipeId))?.pictures ?? [];
        pictures
            .where((picture) => !picture.isLocal && picture.path != null)
            .forEach((picture) => StorageService.deleteFromPath(picture.path!));

        await iterations(recipeId).deleteAll();
      },
    );
  }

  FirestoreClient<Iteration> iterations(String recipeId) {
    final collectionPath = buildPath([
      _FirestoreCollectionName.recipes,
      recipeId,
      _FirestoreCollectionName.iterations,
    ]);

    return FirestoreClient<Iteration>(
      collectionPath,
      IterationSerializer(),
      filterAdapter: FirestoreFilterAdapter(),
      onCreate: (iteration) async {
        final recipe = await recipes.get(iteration.recipeId);
        await recipes.update(
          recipe!.copyWith(
            updatedAt: DateTime.now(),
            iterationCount: recipe.iterationCount + 1,
          ),
        );
      },
      onUpdate: (iteration) async {
        final recipe = await recipes.get(iteration.recipeId);
        await recipes.update(
          recipe!.copyWith(
            updatedAt: DateTime.now(),
          ),
        );
      },
      onDelete: (iterationId) async {
        final iteration = await iterations(recipeId).get(iterationId);
        final recipe = await recipes.get(iteration!.recipeId);
        await recipes.update(
          recipe!.copyWith(
            updatedAt: DateTime.now(),
            iterationCount: recipe.iterationCount - 1,
          ),
        );
        final pictures =
            iteration.reviews.expand((review) => review.pictures).toList();
        pictures
            .where((picture) => !picture.isLocal && picture.path != null)
            .forEach((picture) => StorageService.deleteFromPath(picture.path!));
      },
    );
  }
}
