import 'package:dishful/common/services/db.dart';
import 'package:dishful/common/services/route.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishful/common/theme/theme_data.dart';

void main() async {
  setUpRoutes();
  await setUpDb();
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
      onGenerateRoute: FluroRouter.appRouter.generator,
    );
  }
}
