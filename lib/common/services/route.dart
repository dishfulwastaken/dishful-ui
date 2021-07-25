import 'package:dishful/pages/recipes/recipes.widget.dart';
import 'package:dishful/pages/recipe/recipe.widget.dart';
import 'package:dishful/pages/home/home.widget.dart';
import 'package:fluro/fluro.dart';

class RoutePath {
  static const home = '/';
  static const recipes = '/recipes';
  static const recipe = '/recipes/:id';
}

class RouteHandler {
  static final home = Handler(handlerFunc: (context, params) {
    return Home();
  });
  static final recipes = Handler(handlerFunc: (context, params) {
    return Recipes();
  });
  static final recipe = Handler(handlerFunc: (context, params) {
    /// TODO: get strong typing on params.
    final id = params['id']?.first ?? '';
    return Recipe(id);
  });
}

void setUpRoutes() {
  FluroRouter.appRouter.define(RoutePath.home, handler: RouteHandler.home);
  FluroRouter.appRouter
      .define(RoutePath.recipes, handler: RouteHandler.recipes);
  FluroRouter.appRouter.define(RoutePath.recipe, handler: RouteHandler.recipe);
}
