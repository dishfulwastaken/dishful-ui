import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'db/firebase_options.dart';

class _FunctionName {
  static const _base = 'dishful_function';
  static const fetch = '${_base}_fetch_html';
}

class FunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Current user can be accessed via singleton:
    /// [FirebaseAuth.instance.currentUser].
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<String> fetchHtml(String url) async {
    _functions.useFunctionsEmulator("localhost", 5001);
    HttpsCallable callable = _functions.httpsCallable(_FunctionName.fetch);
    final results = await callable(url);
    print('RESULT: ');
    print(results);
    String html = results.data;

    return html;
  }
}
