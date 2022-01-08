part of ingress;

final testUrlA =
    "https://www.allrecipes.com/recipe/247026/spicy-chile-oil-squid/?printview";

class AllRecipesAdapter extends Adapter {
  bool canParse(String url) => url.contains("allrecipes");

  String sanitizeUrl(String url) => url;

  RecipeIngredient? recipeIngredient(Document document) =>
      throw UnimplementedError();

  RecipeIteration? recipeIteration(Document document) =>
      throw UnimplementedError();

  RecipeMeta? recipeMeta(Document document) => throw UnimplementedError();

  RecipeReview? recipeReview(Document document) => throw UnimplementedError();

  RecipeStep? recipeStep(Document document) => throw UnimplementedError();
}
