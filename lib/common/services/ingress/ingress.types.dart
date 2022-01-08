part of ingress;

abstract class Adapter {
  /// Whether the Adapter can parse the HTML
  /// for the [url].
  bool canParse(String url);

  /// Clean the [url].
  /// This involves checking for anything malicious while
  /// also preparing the [url] to be fetched (if needed).
  String sanitizeUrl(String url);

  /// Try to create a [RecipeIngredient] from the
  /// [document].
  RecipeIngredient? recipeIngredient(Document document);

  /// Try to create a [RecipeIteration] from the
  /// [document].
  RecipeIteration? recipeIteration(Document document);

  /// Try to create a [RecipeMeta] from the
  /// [document].
  RecipeMeta? recipeMeta(Document document);

  /// Try to create a [RecipeReview] from the
  /// [document].
  RecipeReview? recipeReview(Document document);

  /// Try to create a [RecipeStep] from the
  /// [document].
  RecipeStep? recipeStep(Document document);
}
