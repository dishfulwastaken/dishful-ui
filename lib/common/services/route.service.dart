import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/preferences.service.dart';
import 'package:dishful/pages/error/error.widget.dart';
import 'package:dishful/pages/landing/landing.widget.dart';
import 'package:dishful/pages/profile/profile.widget.dart';
import 'package:dishful/pages/recipes/recipes.widget.dart';
import 'package:dishful/pages/recipe/recipe.widget.dart';
import 'package:dishful/pages/auth/auth.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum _Route { landing, auth, profile, recipes, recipe, iteration }

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

          return RecipePage(
            recipeId,
            initialRecipe: recipe,
            iterationId: null,
          );
        },
        redirect: (state) {
          final recipeId = state.params['recipeId']!;
          final lastOpenedIterationId =
              PreferencesService.getLastOpenedIteration(recipeId: recipeId);

          if (lastOpenedIterationId != null)
            return '/recipes/$recipeId/iteration/$lastOpenedIterationId';

          return null;
        }),
    GoRoute(
      name: _Route.iteration.toString(),
      path: '/recipes/:recipeId/iteration/:iterationId',
      builder: (context, state) {
        final recipeId = state.params['recipeId']!;
        final recipe = state.extra as Recipe?;
        final iterationId = state.params['iterationId'];

        return RecipePage(
          recipeId,
          initialRecipe: recipe,
          iterationId: iterationId,
        );
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

  static void goRecipe(String recipeId, {Recipe? recipe, String? iterationId}) {
    final routeName = iterationId != null
        ? _Route.iteration.toString()
        : _Route.recipe.toString();
    final params = {
      'recipeId': recipeId,
      if (iterationId != null) 'iterationId': iterationId,
    };

    _router.goNamed(
      routeName,
      params: params,
      extra: recipe,
    );
  }

  static void pop() {
    _router.pop();
  }

  static RouteInformationParser<Object> get routeInformationParser =>
      _router.routeInformationParser;
  static RouterDelegate<Object> get routerDelegate => _router.routerDelegate;
  static RouteInformationProvider get routeInformationProvider =>
      _router.routeInformationProvider;
}
