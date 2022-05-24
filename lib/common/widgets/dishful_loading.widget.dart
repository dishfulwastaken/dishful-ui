import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DishfulLoading extends StatelessWidget {
  final bool light;
  final bool noBackground;
  final double? size;

  const DishfulLoading({
    Key? key,
    this.light = false,
    this.noBackground = false,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Wrap in a [Scaffold] for situations where [DishfulLoading] is
    /// rendered without a parent [Scaffold].
    return Container(
      width: size,
      height: size,
      child: Scaffold(
        backgroundColor: noBackground ? Colors.transparent : null,
        body: Center(
          child: LoadingAnimationWidget.newtonCradle(
            color: light ? Palette.white : Palette.primary,
            size: context.width * 0.3,
          ),
        ),
      ),
    );
  }
}
