library ingress;

import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'functions.service.dart';

part 'ingress/ingress_allrecipes.dart';
part 'ingress/ingress_foodnetwork.dart';

class IngressService {
  final String url;
  late final Document document;

  IngressService.forUrl(this.url);

  Future<void> init() async {
    final html = await FunctionsService.fetchHtml(testUrlA);
    document = parse(html);
  }

  RecipeMeta get recipeMeta {
    return RecipeMeta.create(name: 'name', description: 'description');
  }
}
