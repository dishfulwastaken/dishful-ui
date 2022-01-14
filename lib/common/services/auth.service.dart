import 'package:dishful/common/services/db.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dishful/common/data/env.dart';

import 'cloud.service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static SubscriptionCancel watchCurrentUser(
    SubscriptionOnData<User> onData,
    SubscriptionOnError onError,
  ) {
    final subscription = _auth.authStateChanges().listen(
      (user) {
        if (user == null) return;
        onData(user);
      },
      onError: onError,
    );

    return subscription.cancel;
  }

  static Future<void> init() async {
    assert(CloudService.ready, "CloudService.init must be called first!");

    // TODO: configure mock port setup
    // if (Env.isMock) _auth.useAuthEmulator("localhost", 5001);
  }

  static Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
