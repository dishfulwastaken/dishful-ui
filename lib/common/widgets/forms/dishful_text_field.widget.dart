import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/widgets/forms/dishful_form_field.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DishfulTextField extends ConsumerWidget with DishfulFormField<String> {
  final _controller = TextEditingController();

  final String name;
  final String hintText;
  final String? labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<String? Function(String?)>? additionalValidators;

  final Color? cursorColor;
  final Color? textColor;
  final Color? fillColor;
  final Color? hintTextColor;
  final Color? iconColor;

  String getValue(FormBuilderState formBuilderState) =>
      getRawValue(formBuilderState) ?? _controller.text;

  void clear(FormBuilderState formBuilderState) {
    setRawValue(formBuilderState, to: "");
    _controller.clear();
  }

  DishfulTextField({
    required this.name,
    required this.hintText,
    required this.icon,
    this.labelText,
    this.keyboardType,
    this.additionalValidators,
    this.obscureText = false,
    this.cursorColor,
    this.textColor,
    this.fillColor,
    this.hintTextColor,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  static DishfulTextField email(BuildContext context) => DishfulTextField(
        name: "email",
        hintText: "Email address",
        icon: Icons.email,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        additionalValidators: [FormBuilderValidators.email()],
        cursorColor: Colors.white,
        textColor: Palette.white,
        fillColor: Palette.primaryLight,
        hintTextColor: Palette.white,
        iconColor: Palette.white,
      );

  static DishfulTextField password(BuildContext context) => DishfulTextField(
        name: "password",
        hintText: "Password",
        icon: Icons.lock,
        obscureText: true,
        additionalValidators: [],
        cursorColor: Colors.white,
        textColor: Palette.white,
        fillColor: Palette.primaryLight,
        hintTextColor: Palette.white,
        iconColor: Palette.white,
      );

  static DishfulTextField confirmPassword(
    BuildContext context, {
    required String? Function(String?) passwordMatchValidator,
  }) =>
      DishfulTextField(
        name: "confirm-password",
        hintText: "Confirm Password",
        icon: Icons.lock,
        obscureText: true,
        additionalValidators: [passwordMatchValidator],
        cursorColor: Colors.white,
        textColor: Palette.white,
        fillColor: Palette.primaryLight,
        hintTextColor: Palette.white,
        iconColor: Palette.white,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderTextField(
      name: name,
      controller: _controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        ...additionalValidators ?? [],
      ]),
      textAlignVertical: TextAlignVertical.center,
      style: context.bodySmall!.copyWith(color: textColor),
      cursorColor: cursorColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: context.bodySmall!.copyWith(color: Palette.grey),
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: context.bodySmall!.copyWith(color: hintTextColor),
        prefixIcon: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
