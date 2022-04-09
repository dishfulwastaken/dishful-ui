library ingress;

import 'package:dishful/common/domain/ingredient.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/domain/review.dart';
import 'package:dishful/common/domain/instruction.dart';

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

    throw "No adapter can parse the given url: $url";
  }

  Future<void> init() async {
    final html = await FunctionsService.fetchHtml(testUrlA);
    _document = parse(html);
  }

  Recipe? get recipe {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.recipe(_document!);
  }

  Iteration? get iteration {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.iteration(_document!);
  }

  Ingredient? get ingredient {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.ingredient(_document!);
  }

  Instruction? get instruction {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.instruction(_document!);
  }

  Review? get review {
    assert(_document != null, "IngressService.init must be called first!");
    return _adapter.review(_document!);
  }
}
