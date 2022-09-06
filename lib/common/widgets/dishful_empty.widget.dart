import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/widgets/dishful_icon_text.widget.dart';
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
        Icon(Icons.folder_off_rounded),
        Container(height: 8),
        Text(
          "No ${subject}s found...",
          textAlign: TextAlign.center,
          style: context.titleSmall,
        ),
        Container(height: 26),
        TextButton(
          onPressed: onPressed,
          child: DishfulIconText(
            text: "New $subject",
            iconData: Icons.add_rounded,
            stretch: false,
          ),
        ),
      ],
    );
  }
}
