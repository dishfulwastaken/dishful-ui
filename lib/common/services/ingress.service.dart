library ingress;

import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';

import 'package:http/http.dart';

part 'ingress/ingress_allrecipes.dart';
part 'ingress/ingress_foodnetwork.dart';

class IngressService {
  final String url;
  late final Document document;
  final client = Client();

  IngressService.fromUrl(this.url);

  void init() async {}
}
