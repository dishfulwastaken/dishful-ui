library ingress;

import 'package:dishful/common/domain/recipe_ingredient.dart';
import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/domain/recipe_review.dart';
import 'package:dishful/common/domain/recipe_step.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'functions.service.dart';

part 'ingress/ingress_allrecipes.dart';
part 'ingress/ingress_foodnetwork.dart';
part 'ingress/ingress.types.dart';

final _allRecipesAdapter = AllRecipesAdapter();
final _foodNetworkAdapter = FoodNetworkAdapter();

class IngressService {
  final String url;
  late final Adapter _adapter;
  late final Document? _document;

  IngressService.forUrl(this.url) {
    if (_allRecipesAdapter.canParse(url)) _adapter = _allRecipesAdapter;
    if (_foodNetworkAdapter.canParse(url)) _adapter = _foodNetworkAdapter;

    throw Exception("No adapter can parse the given url: $url");
  }

  Future<void> init() async {
    final html = await FunctionsService.fetchHtml(testUrlA);
    _document = parse(html);
  }

  RecipeMeta? get recipeMeta {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.recipeMeta(_document!);
  }

  RecipeIteration? get recipeIteration {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.recipeIteration(_document!);
  }

  RecipeIngredient? get recipeIngredient {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.recipeIngredient(_document!);
  }

  RecipeStep? get recipeStep {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.recipeStep(_document!);
  }

  RecipeReview? get recipeReview {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.recipeReview(_document!);
  }
}
