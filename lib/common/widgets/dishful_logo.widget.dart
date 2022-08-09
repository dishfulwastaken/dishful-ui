import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DishfulLogo extends StatelessWidget {
  final double size;
  final Color placeholderColor;

  const DishfulLogo({
    Key? key,
    required this.size,
    required this.placeholderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: SvgPicture.asset(
        "temp-logo.svg",
        width: size,
        height: size,
        fit: BoxFit.fill,
        placeholderBuilder: (context) => ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SizedBox(
            width: 125,
            height: 125,
            child: Container(
              decoration: BoxDecoration(
                color: placeholderColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
