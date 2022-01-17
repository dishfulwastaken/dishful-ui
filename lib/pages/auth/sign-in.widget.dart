import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-field.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final void Function() toSignUp;

  SignIn({
    required this.toSignUp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailField = AuthTextField.email(context);
    final passwordField = AuthTextField.password(context);
    final forgotPasswordText = AuthTextButton(
      text: "Forgot password?",
      onPressed: () => print("Forgot password lol"),
      alignment: Alignment.centerRight,
    );
    final signInButton = AuthButton(
      text: "Sign in",
      onPressed: () async {
        final formState = _formKey.currentState!..save();

        if (formState.validate()) {
          try {
            await AuthService.signIn(
              email: formState.value["email"],
              password: formState.value["password"],
            );
            RouteService.goToRecipes(context, clearStack: true);
          } on AuthException<SignInAuthExceptionCode> catch (error) {
            switch (error.code) {
              case SignInAuthExceptionCode.passwordWrong:
                formState.invalidateField(
                  name: "password",
                  errorText: error.message,
                );
                passwordField.clear();
                break;
              case SignInAuthExceptionCode.userDisabled:
              case SignInAuthExceptionCode.userNotFoundWithEmail:
              default:
                formState.invalidateField(
                  name: "email",
                  errorText: error.message,
                );
                break;
            }
          }
        }
      },
    );
    final signUpText = AuthTextButton(
      text: "Or sign up",
      onPressed: toSignUp,
      rightIcon: FontAwesomeIcons.longArrowAltRight,
    );

    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          emailField,
          Container(height: 12),
          passwordField,
          forgotPasswordText,
          Container(height: 18),
          signInButton,
          signUpText,
        ],
      ),
    );
  }
}
