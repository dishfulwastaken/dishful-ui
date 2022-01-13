part of db;

class _FirebaseCollectionName {
  static const _base = 'dishful_firebase_storage';
  static const user = '${_base}_user';
  static const recipeMeta = '${_base}_recipe_meta';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeReview = '${_base}_recipe_review';
}

class FirebaseClient<T extends Serializable> extends Client<T> {
  final SubcollectionDeleter? subcollectionDeleter;
  late final CollectionReference<T?> _collection;

  FirebaseClient(
    String collectionPath,
    Serializer<T> serializer, {
    this.subcollectionDeleter,
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
    await subcollectionDeleter?.call(arg: id);
    await _collection.doc(id).delete();
  }

  Future<void> deleteAll() async {
    final docs = (await _collection.get()).docs;
    docs.forEach((element) async {
      await subcollectionDeleter?.call(arg: element.id);
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

  FirebaseClient<RecipeMeta> get recipeMeta {
    return FirebaseClient<RecipeMeta>(
      _FirebaseCollectionName.recipeMeta,
      RecipeMetaSerializer(),
      subcollectionDeleter: ({arg}) async {
        await recipeIteration(arg).deleteAll();
      },
    );
  }

  FirebaseClient<RecipeIteration> recipeIteration(String recipeId) {
    final collectionPath = _FirebaseCollectionName.recipeMeta +
        '/$recipeId/' +
        _FirebaseCollectionName.recipeIteration;
    return FirebaseClient<RecipeIteration>(
      collectionPath,
      RecipeIterationSerializer(),
    );
  }

  FirebaseClient<RecipeReview> get recipeReview {
    return FirebaseClient<RecipeReview>(
      _FirebaseCollectionName.recipeReview,
      RecipeReviewSerializer(),
    );
  }
}
