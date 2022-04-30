import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

class DishfulScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? drawer;
  final Widget? leading;
  final Widget? action;

  const DishfulScaffold({
    Key? key,
    required this.title,
    this.subtitle,
    required this.body,
    this.drawer,
    this.leading,
    this.action,
  })  : assert(drawer != null || leading != null),
        super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (leading != null) leading!,
                if (action != null) action!
              ],
            ),
            Container(height: 20),
            Text(title, style: context.titleLarge),
            if (subtitle != null) ...[
              Container(height: 10),
              Text(
                subtitle!,
                style: context.bodyMedium!.copyWith(color: Palette.grey),
              ),
            ],
            Container(height: 16),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
