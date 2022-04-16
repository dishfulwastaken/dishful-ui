part of db;

class _FirestoreCollectionName {
  static const _base = 'dishful_firestore_db';
  static const subscribers = '${_base}_subscribers';
  static const collabs = '${_base}_collabs';
  static const recipes = '${_base}_recipes';
  static const iterations = '${_base}_iterations';
}

class FirestoreClient<T extends Serializable> extends Client<T> {
  final OnCreateHook<T>? onCreate;
  final OnReadHook<T>? onRead;
  final OnUpdateHook<T>? onUpdate;
  final OnDeleteHook? onDelete;
  late final CollectionReference<T?> _collection;

  FirestoreClient(
    String collectionPath,
    Serializer<T> serializer, {
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

  Future<void> deleteAll({Map<String, String>? filters}) async {
    final query = filters == null
        ? _collection
        : filters.entries.fold<Query<T?>>(
            _collection,
            (previousValue, filter) => previousValue.where(
              filter.key,
              isEqualTo: filter.value,
            ),
          );

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

  Future<List<T>> getAll({Map<String, String>? filters}) async {
    final query = filters == null
        ? _collection
        : filters.entries.fold<Query<T?>>(
            _collection,
            (previousValue, filter) => previousValue.where(
              filter.key,
              isEqualTo: filter.value,
            ),
          );

    final docs = (await query.get()).docs;
    final data = extractNonNullData(docs).toList();
    data.forEach((item) async => await onRead?.call(item));

    return data;
  }

  Future<void> update(T data) async {
    await onUpdate?.call(data);
    await _collection.doc(data.id).set(data);
  }

  Stream<List<T>> watchAll({Map<String, String>? filters}) {
    final query = filters == null
        ? _collection
        : filters.entries.fold<Query<T?>>(
            _collection,
            (previousValue, filter) => previousValue.where(
              filter.key,
              isEqualTo: filter.value,
            ),
          );
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

  FirestoreClient<Subscriber> get subscribers {
    final collectionPath = _FirestoreCollectionName.subscribers;

    return FirestoreClient<Subscriber>(
      collectionPath,
      SubscriberSerializer(),
      onDelete: (userId) async {
        await recipes.deleteAll();
      },
    );
  }

  FirestoreClient<Collab> get collabs {
    final collectionPath = _FirestoreCollectionName.collabs;

    return FirestoreClient<Collab>(
      collectionPath,
      CollabSerializer(),
    );
  }

  FirestoreClient<Recipe> get recipes {
    final collectionPath = _FirestoreCollectionName.recipes;

    return FirestoreClient<Recipe>(
      collectionPath,
      RecipeSerializer(),
      onDelete: (recipeId) async {
        final pictures = (await recipes.get(recipeId))?.pictures ?? [];
        pictures
            .where((picture) => !picture.isLocal)
            .forEach((picture) => StorageService.deleteFromPath(picture.path));

        await iterations(recipeId).deleteAll();
        await collabs.deleteAll();
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
            .where((picture) => !picture.isLocal)
            .forEach((picture) => StorageService.deleteFromPath(picture.path));
      },
    );
  }
}
