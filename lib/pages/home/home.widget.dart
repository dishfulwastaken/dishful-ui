import 'package:dishful/common/services/route.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dishful UI')),
      body: Center(
        child: TextButton(
          child: Text('Welcome, Logan'),
          onPressed: () {
            RouteService.goToRecipes(context);
          },
        ),
      ),
    );
  }
}
