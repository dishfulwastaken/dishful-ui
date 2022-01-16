import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/cloud.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/functions.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RouteService.init();
  await CloudService.init();
  await AuthService.init();
  await DbService.initPrivateDb();
  await DbService.initPublicDb();
  await FunctionsService.init();
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
      localizationsDelegates: [FormBuilderLocalizations.delegate],
    );
  }
}
