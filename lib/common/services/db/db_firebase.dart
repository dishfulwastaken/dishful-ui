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
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> close() async {}
  Client<RecipeMeta> get recipeMeta => FirebaseClient<RecipeMeta>();
  Client<RecipeIngredient> get recipeIngredient => throw UnimplementedError();
  Client<RecipeIteration> get recipeIteration => throw UnimplementedError();
  Client<RecipeReview> get recipeReview => throw UnimplementedError();
  Client<RecipeStep> get recipeStep => throw UnimplementedError();
}
