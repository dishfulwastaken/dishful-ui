part of db;

class _FirebaseCollectionName {
  static const _base = 'dishful_firebase_storage';
  static const userMeta = '${_base}_user_meta';
  static const recipeMeta = '${_base}_recipe_meta';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeReview = '${_base}_recipe_review';
}

class FirebaseClient<T extends Serializable> extends Client<T> {
  final OnDeleteCallback? onDelete;
  late final CollectionReference<T?> _collection;

  FirebaseClient(
    String collectionPath,
    Serializer<T> serializer, {
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

    final t = _collection.where('userId', isEqualTo: 'test');
  }

  List<T> filterNullDocs<T>(List<QueryDocumentSnapshot<T?>> docs) {
    return docs.fold([], (previousValue, element) {
      if (element.exists) previousValue.add(element.data()!);

      return previousValue;
    });
  }

  Future<void> create(T data) async {
    await _collection.doc(data.id).set(data);
  }

  Future<void> delete(String id) async {
    await onDelete?.call(id);
    await _collection.doc(id).delete();
  }

  Future<void> deleteAll() async {
    final docs = (await _collection.get()).docs;
    docs.forEach((element) async {
      await onDelete?.call(element.id);
      element.reference.delete();
    });
  }

  Future<T?> get(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.data();
  }

  Future<List<T>> getAll() async {
    // TODO: auth
    // final docs =
    //     (await _collection.where('userId', isEqualTo: 'test').get()).docs;
    final docs = (await _collection.get()).docs;
    final data = filterNullDocs(docs);
    return data.toList();
  }

  Future<void> update(T data) async {
    await _collection.doc(data.id).set(data);
  }

  SubscriptionCancel watchAll(
    SubscriptionOnData<List<T>> onData,
    SubscriptionOnError onError,
  ) {
    final subscription = _collection.snapshots().listen(
      (querySnapshot) {
        final data = filterNullDocs(querySnapshot.docs);
        onData(data.toList());
      },
      onError: onError,
    );

    return subscription.cancel;
  }

  SubscriptionCancel watch(
    String id,
    SubscriptionOnData<T> onData,
    SubscriptionOnError onError,
  ) {
    final subscription = _collection.doc(id).snapshots().listen(
      (documentSnapshot) {
        if (!documentSnapshot.exists) return;
        final data = documentSnapshot.data()!;
        onData(data);
      },
      onError: onError,
    );

    return subscription.cancel;
  }
}

class FirebaseDb extends Db {
  Future<void> init() async {
    assert(CloudService.ready, "CloudService.init must be called first!");

    if (Env.isMock)
      FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
  }

  Future<void> close() async {}

  FirebaseClient<UserMeta> get userMeta {
    final collectionPath = _FirebaseCollectionName.userMeta;

    return FirebaseClient<UserMeta>(
      collectionPath,
      UserMetaSerializer(),
      onDelete: (userId) async {
        await recipeMeta(userId: userId).deleteAll();
      },
    );
  }

  FirebaseClient<RecipeMeta> recipeMeta({String? userId}) {
    userId ??= AuthService.currentUser?.uid;
    final collectionPath = _FirebaseCollectionName.userMeta +
        "/$userId/" +
        _FirebaseCollectionName.recipeMeta;

    return FirebaseClient<RecipeMeta>(
      collectionPath,
      RecipeMetaSerializer(),
      onDelete: (recipeId) async {
        final images = (await recipeMeta().get(recipeId))?.image ?? [];
        images
            .where((image) => !image.isLocal)
            .forEach((image) => StorageService.deleteFromPath(image.path));

        await recipeIteration(recipeId, userId: userId).deleteAll();
      },
    );
  }

  FirebaseClient<RecipeIteration> recipeIteration(
    String recipeId, {
    String? userId,
  }) {
    userId ??= AuthService.currentUser?.uid;
    final collectionPath = _FirebaseCollectionName.userMeta +
        "/$userId/" +
        _FirebaseCollectionName.recipeMeta +
        "/$recipeId/" +
        _FirebaseCollectionName.recipeIteration;

    return FirebaseClient<RecipeIteration>(
      collectionPath,
      RecipeIterationSerializer(),
      onDelete: (iterationId) async {
        await recipeReview(recipeId, iterationId, userId: userId).deleteAll();
      },
    );
  }

  FirebaseClient<RecipeReview> recipeReview(
    String recipeId,
    String iterationId, {
    String? userId,
  }) {
    userId ??= AuthService.currentUser?.uid;
    final collectionPath = _FirebaseCollectionName.userMeta +
        "/$userId/" +
        _FirebaseCollectionName.recipeMeta +
        "/$recipeId/" +
        _FirebaseCollectionName.recipeIteration +
        "/$iterationId/" +
        _FirebaseCollectionName.recipeReview;

    return FirebaseClient<RecipeReview>(
      collectionPath,
      RecipeReviewSerializer(),
    );
  }
}
