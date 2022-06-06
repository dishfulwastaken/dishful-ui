import 'package:dishful/common/domain/subscription.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/widgets/forms/dishful_text_field.widget.dart';
import 'package:dishful/pages/auth/auth-button.widget.dart';
import 'package:dishful/pages/auth/auth-text-button.widget.dart';
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
    final emailField = DishfulTextField.email(context);
    final passwordField = DishfulTextField.password(context);
    final confirmPasswordField = DishfulTextField.confirmPassword(
      context,
      passwordMatchValidator: (value) =>
          value == passwordField.getValue(_formKey.currentState!)
              ? null
              : "This field must match the password.",
    );
    final signUpButton = AuthButton(
      text: "Sign up",
      onPressed: () async {
        final formState = _formKey.currentState!..save();

        if (formState.validate()) {
          try {
            final email = emailField.getValue(formState);
            final password = passwordField.getValue(formState);
            final userId = await AuthService.signUp(
              email: email,
              password: password,
            );

            final subscription = Subscription.create(id: userId);
            await DbService.publicDb.subscriptions.create(subscription);

            context.goRecipes();
          } on AuthException<SignUpAuthExceptionCode> catch (error) {
            switch (error.code) {
              case SignUpAuthExceptionCode.passwordWeak:
                passwordField.invalidate(formState, error.message);
                passwordField.clear(formState);
                confirmPasswordField.clear(formState);
                break;
              case SignUpAuthExceptionCode.emailTaken:
              default:
                emailField.invalidate(formState, error.message);
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
