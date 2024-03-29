import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/widgets/animations/fade_scale.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_button.widget.dart';
import 'package:dishful/common/widgets/dishful_icon_text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isOpenProvider = StateProvider((_) => false);

class DishfulMenu extends ConsumerWidget {
  final List<DishfulMenuItem> items;

  const DishfulMenu({required this.items, Key? key}) : super(key: key);

  Widget buildSpacer(bool isTop) {
    final radius = 4.0;
    final borderRadius = BorderRadius.vertical(
      top: isTop ? Radius.circular(radius) : Radius.zero,
      bottom: !isTop ? Radius.circular(radius) : Radius.zero,
    );
    return Container(
      height: radius * 3,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isOpenProvider);

    return Stack(
      children: [
        PortalTarget(
          visible: true,
          anchor: const Aligned(
            follower: Alignment.topRight,
            target: Alignment.bottomLeft,
          ),
          child: IgnorePointer(
            ignoring: isOpen,
            child: DishfulIconButton(
              onPressed: () => ref.set(isOpenProvider, true),
              icon: Icon(Icons.more_horiz_rounded),
            ),
          ),
          portalFollower: IgnorePointer(
            ignoring: !isOpen,
            child: FadeScaleContainer(
              isVisibleProvider: isOpenProvider,
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildSpacer(true),
                    Container(
                      /// Fix weird spacing glitch where a 1px gap can sometimes
                      /// be seen in between the items; this just paints a white
                      /// background so it can never be seen.
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items,
                      ),
                    ),
                    buildSpacer(false),
                  ],
                ),
              ),
            ),
          ),
        ),
        PortalTarget(
          visible: isOpen,
          child: Container(),
          portalFollower: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ref.set(isOpenProvider, false),
          ),
        ),
      ],
    );
  }
}

class DishfulMenuItem extends ConsumerWidget {
  final String text;
  final IconData iconData;
  final void Function() onTap;

  const DishfulMenuItem({
    required this.text,
    required this.iconData,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Cannot use [TextButton.icon] here because the
    /// [Row] that it arranges the icon & label in centers them;
    /// we want to justify start.
    return TextButton(
      style: ButtonStyle(
        /// Removes the rounded corners from the button
        shape: MaterialStateProperty.all(RoundedRectangleBorder()),
      ),
      onPressed: () {
        ref.set(isOpenProvider, false);
        onTap();
      },
      child: DishfulIconText(text: text, iconData: iconData),
    );
  }
}
