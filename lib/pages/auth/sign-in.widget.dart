import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-field.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatelessWidget {
  final void Function() toSignUp;

  SignIn({
    required this.toSignUp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailField = AuthTextField(hintText: "Email", icon: Icons.email);
    final passwordField = AuthTextField(
      hintText: "Password",
      icon: Icons.lock,
      isSecret: true,
    );
    final forgotPasswordText = AuthTextButton(
      text: "Forgot password?",
      onPressed: () => print("Forgot password lol"),
      rightAligned: true,
    );
    final signInButton = AuthButton(
      text: "Sign in",
      onPressed: () => AuthService.signIn(
        email: emailField.text,
        password: passwordField.text,
      ),
    );
    final signUpText = AuthTextButton(
      text: "Or sign up",
      onPressed: toSignUp,
      rightIcon: FontAwesomeIcons.longArrowAltRight,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 72),
          emailField,
          Container(height: 12),
          passwordField,
          forgotPasswordText,
          Container(height: 20),
          signInButton,
          signUpText,
        ],
      ),
    );
  }
}
