import 'package:dishful/common/domain/subscriber.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-field.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUp extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final void Function() toSignIn;

  SignUp({
    required this.toSignIn,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailField = AuthTextField.email(context);
    final passwordField = AuthTextField.password(context);
    final confirmPasswordField = AuthTextField(
      name: "confirm-password",
      hintText: "Confirm Password",
      icon: Icons.lock,
      obscureText: true,
      additionalValidators: [
        (value) => value == passwordField.text
            ? null
            : "This field must match the password."
      ],
    );
    final signUpButton = AuthButton(
      text: "Sign up",
      onPressed: () async {
        final formState = _formKey.currentState!..save();

        if (formState.validate()) {
          try {
            final email = formState.value["email"];
            final password = formState.value["password"];
            final userId = await AuthService.signUp(
              email: email,
              password: password,
            );

            final subscriber = Subscriber.create(id: userId);
            await DbService.publicDb.subscribers.create(subscriber);

            RouteService.goToRecipes(context, clearStack: true);
          } on AuthException<SignUpAuthExceptionCode> catch (error) {
            switch (error.code) {
              case SignUpAuthExceptionCode.passwordWeak:
                formState.invalidateField(
                  name: "password",
                  errorText: error.message,
                );
                passwordField.clear();
                confirmPasswordField.clear();
                break;
              case SignUpAuthExceptionCode.emailTaken:
              default:
                formState.invalidateField(
                  name: "email",
                  errorText: error.message,
                );
                break;
            }
          } on Exception {
            // TODO: some other exception was thrown, show a snackbar
            // that says this to the user
          }
        }
      },
    );
    final signInText = AuthTextButton(
      text: "Or sign in",
      onPressed: toSignIn,
      leftIcon: FontAwesomeIcons.longArrowAltLeft,
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
          Container(height: 12),
          confirmPasswordField,
          Container(height: 46),
          signUpButton,
          signInText,
        ],
      ),
    );
  }
}
