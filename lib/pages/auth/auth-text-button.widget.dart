import 'package:flutter/material.dart';

class AuthTextButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool? rightAligned;
  final bool? leftAligned;

  AuthTextButton({
    required this.text,
    required this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.leftAligned,
    this.rightAligned,
    Key? key,
  }) : super(key: key);

  Widget buildIcon(IconData iconData) => Padding(
        padding: EdgeInsets.all(2),
        child: Icon(
          iconData,
          color: Colors.white,
          size: 22,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rightAligned == true) Spacer(),
          if (rightIcon != null) Container(width: 24),
          if (leftIcon != null) buildIcon(leftIcon!),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          if (leftIcon != null) Container(width: 24),
          if (rightIcon != null) buildIcon(rightIcon!),
          if (leftAligned == true) Spacer(),
        ],
      ),
    );
  }
}
