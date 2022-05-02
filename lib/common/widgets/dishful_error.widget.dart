import 'dart:ui';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

class DishfulError extends StatelessWidget {
  final String error;
  final String stack;

  const DishfulError({
    required this.error,
    required this.stack,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Icon(Icons.error_outline),
        Container(height: 8),
        Text(
          "Something went wrong...",
          textAlign: TextAlign.center,
          style: context.titleSmall,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(26),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Text(
              "Error: \n$error\n\nStack: \n$stack",
              style: TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ),
        ),
      ],
    );
  }
}
