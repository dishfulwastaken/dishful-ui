import 'package:dishful/common/data/color.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Future<void> Function() onPressed;

  AuthButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // This might not work bc we need to navigate...
        // unless we take another optional param like afterPressed
        // TODO: set text to loading
        await onPressed();
        // TODO: reset text to default
      },
      child: Container(
        decoration: BoxDecoration(
          color: HexColor.fromHex("#8fbfaf"),
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.all(17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
