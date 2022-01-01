part of db;

class _FirebaseCollectionName {
  static const _base = 'dishful_firebase_storage';
  static const recipeMeta = '${_base}_recipe_meta';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeReview = '${_base}_recipe_review';
}

class FirebaseClient<T extends Serializable> extends Client<T> {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<void> create(T data) {
    throw UnimplementedError();
  }

  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  Future<T?> get(String id) {
    throw UnimplementedError();
  }

  Future<List<T>> getAll() {
    throw UnimplementedError();
  }

  Future<T> update(String id, Map overrides) {
    throw UnimplementedError();
  }

  Stream<T> watch({String? id}) {
    throw UnimplementedError();
  }
}

class FirebaseDb extends Db {
  FirebaseClient<RecipeMeta>? _recipeMeta;
  FirebaseClient<RecipeIteration>? _recipeIteration;
  FirebaseClient<RecipeReview>? _recipeReview;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _recipeMeta = FirebaseClient<RecipeMeta>();
    _recipeIteration = FirebaseClient<RecipeIteration>();
    _recipeReview = FirebaseClient<RecipeReview>();
  }

  Future<void> close() async {}

  FirebaseClient<RecipeMeta> get recipeMeta {
    assert(_recipeMeta != null, 'FirebaseDb.init must be called first!');
    return _recipeMeta!;
  }

  FirebaseClient<RecipeIteration> get recipeIteration {
    assert(_recipeIteration != null, 'FirebaseDb.init must be called first!');
    return _recipeIteration!;
  }

  FirebaseClient<RecipeReview> get recipeReview {
    assert(_recipeReview != null, 'FirebaseDb.init must be called first!');
    return _recipeReview!;
  }
}
