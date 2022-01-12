import 'package:cloud_functions/cloud_functions.dart';
import 'package:dishful/common/data/env.dart';

import 'cloud.service.dart';

class _FunctionName {
  static const _base = 'dishful_function';
  static const fetchHtml = '${_base}_fetch_html';
}

class FunctionsService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  static Future<void> init() async {
    assert(CloudService.ready, "CloudService.init must be called first!");

    if (Env.isMock) _functions.useFunctionsEmulator("localhost", 5001);
  }

  static Future<String> fetchHtml(String url) async {
    HttpsCallable callable = _functions.httpsCallable(_FunctionName.fetchHtml);
    final results = await callable(url);
    String html = results.data;

    return html;
  }
}
