part of db;

class _FirebaseCollectionName {
  static const _base = 'dishful_firebase_storage';
  static const recipeMeta = '${_base}_recipe_meta';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeReview = '${_base}_recipe_review';
}

class FirebaseClient<T extends Serializable> extends Client<T> {
  late final CollectionReference<T?> _collection;

  FirebaseClient(String collectionPath, Serializer<T> serializer) {
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

  Future<void> create(T data) async {
    await _collection.doc(data.id).set(data);
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }

  Future<T?> get(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.data();
  }

  Future<List<T>> getAll() async {
    final docs = (await _collection.get()).docs;
    final data = docs.fold<List<T>>([], (previousValue, element) {
      if (!element.exists) return previousValue;
      previousValue.add(element.data()!);

      return previousValue;
    });
    return data.toList();
  }

  Future<void> update(T data) async {
    await _collection.doc(data.id).set(data);
  }

  Stream<T?> watch({String? id}) {
    final queryStream = _collection.snapshots();
    final docStream = queryStream.map((query) => query.docs.first);
    final dataStream = docStream.map((doc) => doc.data());
    return dataStream;
  }
}

class FirebaseDb extends Db {
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Current user can be accessed via singleton:
    /// [FirebaseAuth.instance.currentUser].
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> close() async {}

  FirebaseClient<RecipeMeta> get recipeMeta {
    return FirebaseClient<RecipeMeta>(
      _FirebaseCollectionName.recipeMeta,
      RecipeMetaSerializer(),
    );
  }

  FirebaseClient<RecipeIteration> recipeIteration(String recipeId) {
    final collectionPath = _FirebaseCollectionName.recipeMeta +
        recipeId +
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
