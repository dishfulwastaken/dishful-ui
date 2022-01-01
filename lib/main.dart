import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RouteService.setUp();
  await DbService.initPrivateDb();
  runApp(
    ProviderScope(
      child: Dishful(),
    ),
  );
}

class Dishful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishful',
      theme: themeData,
      onGenerateRoute: RouteService.onGenerateRoute,
    );
  }
}
