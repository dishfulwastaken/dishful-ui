import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/subscription.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash/flash.dart';

class ProFeature extends ConsumerWidget {
  late final FutureProvider<Subscription?> subscriberProvider;
  final String why;
  final Widget child;

  ProFeature({
    required this.child,
    required this.why,
    Key? key,
  }) : super(key: key) {
    final id = AuthService.currentUser?.uid;
    if (id == null) throw "No current user";

    subscriberProvider = getProvider(DbService.publicDb.subscriptions, id: id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(
      subscriberProvider.select(
        (value) => value.asData?.value?.isCurrentlySubscribed ?? false,
      ),
    );

    return isPro
        ? child
        : GestureDetector(
            onTap: () => context.showFlashDialog(
              constraints: BoxConstraints(maxWidth: 400),
              title: Text("This is a pro feature :("),
              content: Column(
                children: [
                  Text(
                    "Why?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(why),
                ],
              ),
              positiveActionBuilder: (context, controller, _) {
                return TextButton(
                  onPressed: () {
                    // TODO: open subscription stuff
                    controller.dismiss();
                  },
                  child: Text("Upgrade"),
                );
              },
              negativeActionBuilder: (context, controller, _) {
                return TextButton(
                  onPressed: controller.dismiss,
                  child: Text("Ok"),
                );
              },
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              fit: StackFit.expand,
              children: [
                Icon(
                  FontAwesomeIcons.crown,
                  color: Palette.primaryDark.withAlpha(100),
                ),
                child
              ],
            ),
          );
  }
}
