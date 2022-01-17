import 'package:dishful/common/data/color.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/pages/landing/progress-bar.widget.dart';
import 'package:flutter/material.dart';

import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/cloud.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/functions.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final progressProvider = StateProvider((_) => 0.0);

class LandingPage extends ConsumerWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance?.scheduleFrameCallback((_) async {
      WidgetsFlutterBinding.ensureInitialized();
      ref.set(progressProvider, 0.1);

      await CloudService.init();
      ref.set(progressProvider, 0.8);

      await AuthService.init();
      await DbService.initPrivateDb();
      ref.set(progressProvider, 0.95);

      await DbService.initPublicDb();
      await FunctionsService.init();
      ref.set(progressProvider, 1.0);

      /// Tiny delay for the loading animation to look a *little* nicer.
      ///
      /// With a normal/fast internet speed, everything will initialize
      /// before the animation finishes, so this will give the animation an
      /// additional 40 ms to finish.
      await Future.delayed(Duration(milliseconds: 40));

      RouteService.goToAuth(context);
    });

    return Scaffold(
      backgroundColor: HexColor.fromHex("#ff80aa"),
      body: Center(
        child: Consumer(
          builder: (context, ref, _) {
            final progress = ref.watch(progressProvider);
            return LayoutBuilder(
              builder: (_, constraints) {
                return ProgressBar(
                  width: constraints.maxWidth * 0.5,
                  current: progress,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
