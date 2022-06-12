import 'package:firebase_auth/firebase_auth.dart';
import 'package:dishful/common/data/env.dart';

import 'cloud.service.dart';

class AuthException<T extends Enum> implements Exception {
  final String message;
  final T code;

  AuthException({required this.message, required this.code});
}

enum SignUpAuthExceptionCode { emailTaken, passwordWeak, other }

enum SignInAuthExceptionCode {
  userDisabled,
  userNotFoundWithEmail,
  passwordWrong,
  tooManyAttempts,
  other
}

enum SignOutAuthExceptionCode { other }

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User get currentUser => _auth.currentUser!;

  static Stream<User?> watchCurrentUser() {
    return _auth.userChanges();
  }

  static Future<void> init() async {
    assert(CloudService.ready, "CloudService.init must be called first!");

    if (Env.isMock) _auth.useAuthEmulator("localhost", 9099);
  }

  static Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user!.uid;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "email-already-in-use":
          throw AuthException(
            code: SignUpAuthExceptionCode.emailTaken,
            message: "Email is already taken.",
          );
        case "weak-password":
          throw AuthException(
            code: SignUpAuthExceptionCode.passwordWeak,
            message: "Password must contain 6 or more characters.",
          );
        default:
          throw AuthException(
            code: SignUpAuthExceptionCode.other,
            message: "Error: ${error.code}",
          );
      }
    } on Exception catch (error) {
      print("Unknwon AuthException: $error");
      throw AuthException(
        message: "An unknown error occurred.",
        code: SignUpAuthExceptionCode.other,
      );
    }
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "user-disabled":
          throw AuthException(
            code: SignInAuthExceptionCode.userDisabled,
            message: "User has been disabled.",
          );
        case "user-not-found":
          throw AuthException(
            code: SignInAuthExceptionCode.userNotFoundWithEmail,
            message: "Email has no corresponding user.",
          );
        case "wrong-password":
          throw AuthException(
            code: SignInAuthExceptionCode.passwordWrong,
            message: "Incorrect password.",
          );
        case "too-many-requests":
          throw AuthException(
            code: SignInAuthExceptionCode.tooManyAttempts,
            message: "Too many failed attempts, try again later.",
          );
        default:
          throw AuthException(
            code: SignInAuthExceptionCode.other,
            message: "Error: ${error.code}",
          );
      }
    } on Exception catch (error) {
      print("Unknwon AuthException: $error");
      throw AuthException(
        message: "An unknown error occurred.",
        code: SignInAuthExceptionCode.other,
      );
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on Exception catch (error) {
      print("Unknwon AuthException: $error");
      throw AuthException(
        message: "An unknown error occurred.",
        code: SignOutAuthExceptionCode.other,
      );
    }
  }
}
