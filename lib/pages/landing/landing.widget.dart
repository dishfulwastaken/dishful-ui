import 'package:dishful/common/services/storage.service.dart';
import 'package:dishful/common/widgets/dishful_loading.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/cloud.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/functions.service.dart';
import 'package:dishful/common/services/route.service.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.scheduleFrameCallback((_) async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        await CloudService.init();
        await AuthService.init();
        await DbService.initPrivateDb();
        await DbService.initPublicDb();
        await FunctionsService.init();
        await StorageService.init();
      } catch (_) {
        print("Warning: init may have already been called!");
      }

      RouteService.goToAuth(context);
    });

    return Scaffold(
      backgroundColor: Palette.primary,
      body: Center(child: DishfulLoading(light: true)),
    );
  }
}
