import 'package:dishful/common/data/color.dart';
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

      await CloudService.init();
      await AuthService.init();
      await DbService.initPrivateDb();
      await DbService.initPublicDb();
      await FunctionsService.init();

      RouteService.goToAuth(context);
    });

    return Scaffold(
      backgroundColor: HexColor.fromHex("#ff80aa"),
      body: Center(child: Text("Dishful")),
    );
  }
}
