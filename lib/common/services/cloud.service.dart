import 'package:firebase_core/firebase_core.dart';

import 'cloud/firebase_options.dart';

/// Parent service to [cloud_firestore] and [cloud_functions]
/// dependent services.
///
/// Responsible for initializing the app so the dependent
/// services can be used.
class CloudService {
  static bool _ready = false;
  static bool get ready => _ready;

  static Future<void> init() async {
    await _initApp();

    _ready = true;
  }

  static Future<FirebaseApp> _initApp() => Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
}
