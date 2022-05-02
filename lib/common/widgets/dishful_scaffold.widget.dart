import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/widgets/dishful_drawer.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

class DishfulScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool withDrawer;
  final Widget body;
  final Widget Function(BuildContext)? leading;
  final Widget Function(BuildContext)? action;

  const DishfulScaffold({
    Key? key,
    required this.title,
    this.subtitle,
    this.withDrawer = false,
    required this.body,
    this.leading,
    this.action,
  })  : assert(leading != null),
        super(key: key);

  static DishfulScaffold? maybeOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<DishfulScaffold>();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: withDrawer ? DishfulDrawer() : null,
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (leading != null) leading!(context),
                  if (action != null) action!(context)
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
      ),
    );
  }
}
