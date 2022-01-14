import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-field.widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  final Function toSignIn;
  final emailField = AuthTextField(hintText: "Email", icon: Icons.email);
  final passwordField = AuthTextField(
    hintText: "Password",
    icon: Icons.lock,
    isSecret: true,
  );
  final confirmPasswordField = AuthTextField(
    hintText: "Confirm Password",
    icon: Icons.lock,
    isSecret: true,
  );
  final signUpButton = AuthButton();
  final signInText = AuthTextButton();

  SignUp({
    required this.toSignIn,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        emailField,
        passwordField,
        confirmPasswordField,
        signUpButton,
        signInText,
      ],
    );
  }
}
