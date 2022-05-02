import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

class DishfulIconText extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;
  final Color backgroundColor;
  final bool stretch;

  const DishfulIconText({
    Key? key,
    required this.text,
    required this.iconData,
    this.color = Palette.black,
    this.backgroundColor = Colors.transparent,
    this.stretch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(iconData, color: color),
          Container(width: 10),
          Text(
            text,
            style: context.bodyMedium!.copyWith(
              color: color,
              fontSize: 13,
              height: 1.6,
            ),
          )
        ],
      ),
    );
  }
}
