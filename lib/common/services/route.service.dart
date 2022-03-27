import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/pages/landing/landing.widget.dart';
import 'package:dishful/pages/profile/profile.widget.dart';
import 'package:dishful/pages/recipes/recipes.widget.dart';
import 'package:dishful/pages/recipe/recipe.widget.dart';
import 'package:dishful/pages/auth/auth.widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

typedef _RouteHandler<A> = Widget? Function(
  BuildContext?,
  Map<String, List<String>>,
  Map<String, A>?,
);

class _AppRoute<A> {
  final String path;
  final _RouteHandler<A> handlerFunc;
  final _AppRoute? parent;
  final TransitionType transitionType;
  final Duration transitionDuration;

  _AppRoute({
    required this.path,
    required this.handlerFunc,
    this.parent,
    this.transitionType = TransitionType.native,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  String get fullPath {
    final isParentHome = parent?.parent == null;
    final prefix = isParentHome ? '/' : parent!.fullPath + '/';

    return prefix + path;
  }

  Handler get handler {
    return Handler(handlerFunc: (context, params) {
      final arguments = context?.settings?.arguments as Map<String, A>?;

      return handlerFunc(context, params, arguments);
    });
  }
}

final _landing = _AppRoute(
  path: "",
  handlerFunc: (context, params, args) {
    return LandingPage();
  },
);

final _auth = _AppRoute(
  parent: _landing,
  path: "auth",
  handlerFunc: (context, params, args) {
    return AuthPage();
  },
  transitionType: TransitionType.fadeIn,
  transitionDuration: Duration(seconds: 2),
);

final _profile = _AppRoute(
  parent: _landing,
  path: "profile",
  handlerFunc: (context, params, args) {
    return ProfilePage();
  },
  transitionType: TransitionType.fadeIn,
);

final _recipes = _AppRoute(
  parent: _landing,
  path: "recipes",
  handlerFunc: (context, params, args) {
    return RecipesPage();
  },
  transitionType: TransitionType.fadeIn,
);

final _recipe = _AppRoute(
  parent: _recipes,
  path: ":recipeId",
  handlerFunc: (context, params, args) {
    final id = params["recipeId"]!.first;
    return RecipePage(id);
  },
);

List<_AppRoute> appRoutes = [_landing, _auth, _profile, _recipes, _recipe];

class RouteService {
  static void goToAuth(BuildContext context) {
    _goTo(context, _auth.fullPath, clearStack: true);
  }

  static void goToProfile(BuildContext context) {
    _goTo(context, _profile.fullPath);
  }

  static void goToRecipes(BuildContext context, {bool? clearStack}) {
    _goTo(context, _recipes.fullPath, clearStack: clearStack);
  }

  static void goToRecipe(BuildContext context, String recipeId) {
    final destination = _recipe.fullPath.replaceAll(_recipe.path, recipeId);
    _goTo(context, destination);
  }

  static void _goTo(
    BuildContext context,
    String destination, {
    Map<String, dynamic>? arguments,
    bool? clearStack,
  }) {
    FluroRouter.appRouter.navigateTo(
      context,
      destination,
      clearStack: clearStack ?? false,
      routeSettings: RouteSettings(arguments: arguments),
    );
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    return FluroRouter.appRouter.generator(routeSettings);
  }

  static void init() {
    for (_AppRoute appRoute in appRoutes) {
      FluroRouter.appRouter.define(
        appRoute.fullPath,
        handler: appRoute.handler,
        transitionType: appRoute.transitionType,
        transitionDuration: appRoute.transitionDuration,
      );
    }
  }
}
