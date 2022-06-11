import 'package:dishful/common/domain/subscription.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';

class SubscriptionService {
  static Subscription? _subscription;

  static bool get isCurrentUserSubscribed =>
      _subscription?.isCurrentlySubscribed ?? false;

  static Future<void> signIn() async {
    final userId = AuthService.currentUser.uid;
    _subscription = await DbService.publicDb.subscriptions.get(userId);
  }

  static Future<void> signUp() async {
    final userId = AuthService.currentUser.uid;
    _subscription = Subscription.create(id: userId);
    await DbService.publicDb.subscriptions.create(_subscription!);
  }

  static Future<void> subscribe() async {
    // TODO: Subscribe the current user
  }

  static Future<void> unsubscribe() async {
    // TODO: Unsubscribe the current user
  }
}
