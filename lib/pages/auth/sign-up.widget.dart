import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-field.widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatelessWidget {
  final void Function() toSignIn;

  SignUp({
    required this.toSignIn,
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
    final confirmPasswordField = AuthTextField(
      hintText: "Confirm Password",
      icon: Icons.lock,
      isSecret: true,
    );
    final signUpButton = AuthButton(
      text: "Sign up",
      onPressed: () => AuthService.signUp(
        email: emailField.text,
        password: passwordField.text,
      ),
    );
    final signInText = AuthTextButton(
      text: "Or sign in",
      onPressed: toSignIn,
      leftIcon: FontAwesomeIcons.longArrowAltLeft,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          emailField,
          Container(height: 12),
          passwordField,
          Container(height: 12),
          confirmPasswordField,
          Container(height: 44),
          signUpButton,
          signInText,
        ],
      ),
    );
  }
}
