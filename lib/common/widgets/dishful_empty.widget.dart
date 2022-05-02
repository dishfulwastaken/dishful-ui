import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

class DishfulEmpty extends StatelessWidget {
  final String subject;
  final void Function() onPressed;

  const DishfulEmpty({
    Key? key,
    required this.subject,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.folder_off_outlined),
        Container(height: 8),
        Text(
          "No ${subject}s found...",
          textAlign: TextAlign.center,
          style: context.titleSmall,
        ),
        Container(height: 26),
        TextButton(
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Palette.black),
                Container(width: 8),
                Text("New $subject", style: context.bodyMedium)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
