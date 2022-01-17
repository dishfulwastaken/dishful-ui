import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double current;
  final double width;
  final double height;
  final double radius;
  final Color color;
  final Color backgroundColor;
  final Duration duration;

  ProgressBar({
    Key? key,
    required this.current,
    required this.width,
    this.height = 20.0,
    this.radius = 50.0,
    this.duration = const Duration(milliseconds: 35),
    this.color = Colors.red,
    this.backgroundColor = Colors.redAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = current * width;

    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        AnimatedContainer(
          duration: duration,
          width: progress,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ],
    );
  }
}
