import 'package:firebase_auth/firebase_auth.dart';
import 'package:dishful/common/data/env.dart';

import 'cloud.service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

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
