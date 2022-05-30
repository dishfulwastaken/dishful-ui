import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/widgets/forms/dishful_text_field.widget.dart';
import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
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
    final emailField = DishfulTextField.email(context);
    final passwordField = DishfulTextField.password(context);
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
              email: emailField.getValue(formState),
              password: passwordField.getValue(formState),
            );
            RouteService.goToRecipes(context, clearStack: true);
          } on AuthException<SignInAuthExceptionCode> catch (error) {
            switch (error.code) {
              case SignInAuthExceptionCode.passwordWrong:
                passwordField.invalidate(formState, error.message);
                passwordField.clear(formState);
                break;
              case SignInAuthExceptionCode.userDisabled:
              case SignInAuthExceptionCode.userNotFoundWithEmail:
              default:
                emailField.invalidate(formState, error.message);
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
          /// TODO: REMOVE THIS ITS FOR QUICKLY LOGGING IN
          TextButton(
              onPressed: () {
                emailField.setRawValue(_formKey.currentState!,
                    to: "t@gmail.com");
                passwordField.setRawValue(_formKey.currentState!, to: "123456");
              },
              child: Text('autofill')),
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
