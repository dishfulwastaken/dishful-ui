import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

/// There is no [IconButtonThemeData] as of writing, so this wrapper
/// component applies our own style.
class DishfulIconButton extends StatelessWidget {
  const DishfulIconButton({
    Key? key,
    this.iconSize,
    this.visualDensity,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
    this.splashRadius,
    this.color = Palette.lightGrey,
    this.focusColor,
    this.hoverColor = Palette.lightGrey,
    this.highlightColor,
    this.splashColor = Palette.primaryLight,
    this.disabledColor = Palette.grey,
    required this.onPressed,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback = true,
    this.constraints = const BoxConstraints(),
    required this.icon,
  }) : super(key: key);

  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final double? splashRadius;
  final Widget icon;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? color;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? disabledColor;
  final VoidCallback? onPressed;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool enableFeedback;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      alignment: alignment,
      splashRadius: splashRadius,
      icon: icon,
      focusColor: focusColor,
      hoverColor: hoverColor,
      color: color,
      splashColor: splashColor,
      highlightColor: highlightColor,
      disabledColor: disabledColor,
      onPressed: onPressed,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      tooltip: tooltip,
      enableFeedback: enableFeedback,
      constraints: constraints,
    );
  }
}
