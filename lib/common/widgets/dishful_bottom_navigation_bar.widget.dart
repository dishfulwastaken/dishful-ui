import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:flutter/material.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentIndexProvider = StateProvider((_) => 0);

class DishfulBottomNavigationBar extends ConsumerWidget {
  const DishfulBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Container(
      color: Colors.white,
      width: context.width,
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded), label: ""),
        ],
        onTap: (index) {
          ref.set(currentIndexProvider, index);
          switch (index) {
            case 0:
              RouteService.goToRecipes(context);
              break;
            case 1:
              RouteService.goToRecipes(context);
              break;
            case 2:
              RouteService.goToRecipes(context);
              break;
            case 3:
              RouteService.goToProfile(context);
              break;
          }
        },
        currentIndex: currentIndex,
        iconSize: 32,
      ).paddingSymmetric(horizontal: 40),
    );
  }
}
