import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

void main() {
  RouteService.init();
  runApp(
    ProviderScope(
      child: Portal(
        child: Dishful(),
      ),
    ),
  );
}

class Dishful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dishful',
      theme: themeData,
      onGenerateRoute: RouteService.onGenerateRoute,
      localizationsDelegates: [FormBuilderLocalizations.delegate],
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.autoScale(480, name: MOBILE, scaleFactor: 0.5),
          ResponsiveBreakpoint.resize(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP, scaleFactor: 0.85),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
      ),
    );
  }
}
