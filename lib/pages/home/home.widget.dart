import 'package:dishful/common/services/route.service.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final helloWorldProvider = Provider((_) => 'Go to Recipes');

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(helloWorldProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dishful UI')),
      body: Center(
        child: TextButton(
          child: Text(value),
          onPressed: () {
            FluroRouter.appRouter.navigateTo(context, RoutePath.recipes);
          },
        ),
      ),
    );
  }
}
