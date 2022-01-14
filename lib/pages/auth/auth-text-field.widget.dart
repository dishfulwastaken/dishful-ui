import 'package:flutter/material.dart';
import 'package:dishful/common/data/color.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isSecret;
  final bool isEmail;
  final TextEditingController _controller = TextEditingController();

  String get text => _controller.text;
  void clear() => _controller.clear();

  AuthTextField({
    required this.hintText,
    required this.icon,
    this.isSecret = false,
    this.isEmail = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: HexColor.fromHex("#fda1bf"),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.all(18),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: isEmail ? TextInputType.emailAddress : null,
              obscureText: isSecret,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
