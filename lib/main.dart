import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  RouteService.init();
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
