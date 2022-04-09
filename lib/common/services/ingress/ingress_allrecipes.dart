part of ingress;

final testUrlA =
    "https://www.allrecipes.com/recipe/247026/spicy-chile-oil-squid/?printview";

class AllRecipesAdapter extends Adapter {
  bool canParse(String url) => url.contains("allrecipes");

  String sanitizeUrl(String url) => url;

  @override
  Ingredient? ingredient(Document document) {
    // TODO: implement ingredient
    throw UnimplementedError();
  }

  @override
  Instruction? instruction(Document document) {
    // TODO: implement instruction
    throw UnimplementedError();
  }

  @override
  Iteration? iteration(Document document) {
    // TODO: implement iteration
    throw UnimplementedError();
  }

  @override
  Recipe? recipe(Document document) {
    // TODO: implement recipe
    throw UnimplementedError();
  }

  @override
  Review? review(Document document) {
    // TODO: implement review
    throw UnimplementedError();
  }
}
