import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/widgets/dishful_icon_text.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DrawerRouteKey {
  recipes,
  sharedWithMe,
  profile,
  preferences,
  about,
}

final currentPageProvider = StateProvider((_) => DrawerRouteKey.recipes);

class DishfulDrawer extends StatelessWidget {
  const DishfulDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            height: 160,
            alignment: Alignment.center,
            child: Text("Dishful", style: context.headlineSmall),
          ),
          DishfulDrawerItem(
            text: "My Recipes",
            iconData: Icons.home,
            routeKey: DrawerRouteKey.recipes,
            onPressed: () {
              context.goRecipes();
            },
          ),
          DishfulDrawerItem(
            text: "Shared with Me",
            iconData: Icons.group,
            routeKey: DrawerRouteKey.sharedWithMe,
            onPressed: () {},
          ),
          DishfulDrawerItem(
            text: "Profile",
            iconData: Icons.account_circle,
            routeKey: DrawerRouteKey.profile,
            onPressed: () {
              context.goProfile();
            },
          ),
          DishfulDrawerItem(
            text: "Preferences",
            iconData: Icons.tune,
            routeKey: DrawerRouteKey.preferences,
            onPressed: () {},
          ),
          DishfulDrawerItem(
            text: "About",
            iconData: Icons.info,
            routeKey: DrawerRouteKey.about,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class DishfulDrawerItem extends ConsumerWidget {
  final String text;
  final IconData iconData;
  final DrawerRouteKey routeKey;
  final void Function() onPressed;

  const DishfulDrawerItem({
    Key? key,
    required this.text,
    required this.iconData,
    required this.routeKey,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final isSelected = currentPage == routeKey;

    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () {
        if (currentPage == routeKey) {
          Navigator.maybePop(context);
          return;
        }

        ref.set(currentPageProvider, routeKey);
        onPressed();
      },
      child: DishfulIconText(
        text: text,
        iconData: iconData,
        color: isSelected ? Colors.white : Palette.white,
        backgroundColor: isSelected ? Palette.primaryLight : Palette.primary,
      ),
    );
  }
}
