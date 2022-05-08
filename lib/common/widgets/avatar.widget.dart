import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final void Function() onPressed;
  Avatar({required this.onPressed, Key? key}) : super(key: key);

  String get initials {
    final email = AuthService.currentUser.email!;
    final name = email.split("@").first;

    return name.characters.take(2).toString().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "avatar-tag",
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Palette.primary,
            child: Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                initials,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
