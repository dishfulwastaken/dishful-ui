import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/pages/error/error.widget.dart';
import 'package:dishful/pages/landing/landing.widget.dart';
import 'package:dishful/pages/profile/profile.widget.dart';
import 'package:dishful/pages/recipes/recipes.widget.dart';
import 'package:dishful/pages/recipe/recipe.widget.dart';
import 'package:dishful/pages/auth/auth.widget.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum _Route { landing, auth, profile, recipes, recipe }

final _router = GoRouter(
  errorBuilder: (context, state) => ErrorPage(error: state.error!),
  routes: [
    GoRoute(
      name: _Route.landing.toString(),
      path: '/',
      builder: (context, state) => LandingPage(),
    ),
    GoRoute(
      name: _Route.auth.toString(),
      path: '/auth',
      builder: (context, state) => AuthPage(),
    ),
    GoRoute(
      name: _Route.profile.toString(),
      path: '/profile',
      builder: (context, state) => ProfilePage(),
    ),
    GoRoute(
      name: _Route.recipes.toString(),
      path: '/recipes',
      builder: (context, state) => RecipesPage(),
    ),
    GoRoute(
      name: _Route.recipe.toString(),
      path: '/recipes/:recipeId',
      builder: (context, state) {
        final recipeId = state.params['recipeId']!;
        final recipe = state.extra as Recipe?;
        return RecipePage(recipeId, initialRecipe: recipe);
      },
    )
  ],
);

class RouteService {
  static void goLanding() {
    _router.goNamed(_Route.landing.toString());
  }

  static void goAuth() {
    _router.goNamed(_Route.auth.toString());
  }

  static void goProfile() {
    _router.goNamed(_Route.profile.toString());
  }

  static void goRecipes() {
    _router.goNamed(_Route.recipes.toString());
  }

  static void goRecipe(String recipeId, {Recipe? recipe}) {
    _router.goNamed(
      _Route.recipe.toString(),
      params: {'recipeId': recipeId},
      extra: recipe,
    );
  }

  static RouteInformationParser<Object> get routeInformationParser =>
      _router.routeInformationParser;
  static RouterDelegate<Object> get routerDelegate => _router.routerDelegate;
}
