import 'package:dishful/common/services/route.service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Prefix { lastOpenedIteration }

class PreferencesService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String _getKey(_Prefix prefix, String key) => "$prefix--$key";

  static Future<void> setLastOpenedIteration({
    required String recipeId,
    required String lastOpenedIterationId,
  }) {
    if (_preferences == null) {
      print("Routing to landing page to re-init preferences");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        RouteService.goLanding();
      });
    }

    return _preferences?.setString(
          _getKey(_Prefix.lastOpenedIteration, recipeId),
          lastOpenedIterationId,
        ) ??
        Future.value(null);
  }

  static String? getLastOpenedIteration({required String recipeId}) {
    if (_preferences == null) {
      print("Routing to landing page to re-init preferences");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        RouteService.goLanding();
      });
    }

    return _preferences?.getString(
      _getKey(_Prefix.lastOpenedIteration, recipeId),
    );
  }
}
