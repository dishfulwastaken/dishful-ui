import 'package:dishful/pages/recipes/recipes.widget.dart';
import 'package:dishful/pages/recipe/recipe.widget.dart';
import 'package:dishful/pages/home/home.widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

class RoutePath {
  static const home = '/';
  static const recipes = '/recipes';
  static const recipe = '/recipes/:id';
}

class _RouteHandler {
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

class AppRouter {
  static void goTo(BuildContext context, String destination) {
    FluroRouter.appRouter.navigateTo(context, destination);
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    return FluroRouter.appRouter.generator(routeSettings);
  }

  static void setUp() {
    FluroRouter.appRouter.define(
      RoutePath.home,
      handler: _RouteHandler.home,
    );
    FluroRouter.appRouter.define(
      RoutePath.recipes,
      handler: _RouteHandler.recipes,
    );
    FluroRouter.appRouter.define(
      RoutePath.recipe,
      handler: _RouteHandler.recipe,
    );
  }
}
