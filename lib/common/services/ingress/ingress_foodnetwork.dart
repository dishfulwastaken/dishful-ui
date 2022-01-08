part of ingress;

final testUrlF = "https://foodnetwork.co.uk/recipes/crunchy-noodle-salad/";

class FoodNetworkAdapter extends Adapter {
  bool canParse(String url) => url.contains("foodnetwork");

  String sanitizeUrl(String url) => url;

  RecipeIngredient? recipeIngredient(Document document) =>
      throw UnimplementedError();

  RecipeIteration? recipeIteration(Document document) =>
      throw UnimplementedError();

  RecipeMeta? recipeMeta(Document document) => throw UnimplementedError();

  RecipeReview? recipeReview(Document document) => throw UnimplementedError();

  RecipeStep? recipeStep(Document document) => throw UnimplementedError();
}
