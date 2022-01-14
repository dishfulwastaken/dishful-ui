import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-field.widget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  final Function toSignUp;
  final emailField = AuthTextField(hintText: "Email", icon: Icons.email);
  final passwordField = AuthTextField(
    hintText: "Password",
    icon: Icons.lock,
    isSecret: true,
  );
  final forgotPasswordText = AuthTextButton();
  final signInButton = AuthButton();
  final signUpText = AuthTextButton();

  SignIn({
    required this.toSignUp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        emailField,
        passwordField,
        forgotPasswordText,
        signInButton,
        signUpText,
      ],
    );
  }
}
