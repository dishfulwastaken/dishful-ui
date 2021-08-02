part of db;

class FirebaseClient<T extends Serializable> extends Client<T> {
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

  Future<T> update(String id, Map<String, dynamic> overrides) {
    throw UnimplementedError();
  }

  Stream<T> watch({String? id}) {
    throw UnimplementedError();
  }
}

class FirebaseDb extends Db {
  Client<Recipe> get recipe => throw UnimplementedError();
  Client<RecipeIngredient> get recipeIngredient => throw UnimplementedError();
  Client<RecipeIteration> get recipeIteration => throw UnimplementedError();
  Client<RecipeReview> get recipeReview => throw UnimplementedError();
  Client<RecipeStep> get recipeStep => throw UnimplementedError();
}
