import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:dishful/common/data/color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AuthTextField extends ConsumerWidget {
  final _controller = TextEditingController();

  String get text => _controller.text;
  void clear() => _controller.clear();

  final String name;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<String? Function(String?)>? additionalValidators;

  AuthTextField({
    required this.name,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.additionalValidators,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  AuthTextField.email(BuildContext context)
      : name = "email",
        hintText = "Email address",
        icon = Icons.email,
        obscureText = false,
        keyboardType = TextInputType.emailAddress,
        additionalValidators = [FormBuilderValidators.email(context)];

  AuthTextField.password(BuildContext context)
      : name = "password",
        hintText = "Password",
        icon = Icons.lock,
        obscureText = true,
        keyboardType = null,
        additionalValidators = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderTextField(
      name: name,
      controller: _controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(context),
        ...additionalValidators ?? [],
      ]),
      style: TextStyle(
        fontSize: 13,
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 22),
        filled: true,
        fillColor: Palette.primaryLight,
        errorMaxLines: 2,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
        prefixIcon: Icon(icon, color: Colors.white, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
