import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/widgets/forms/dishful_form_field.widget.dart';
import 'package:dishful/common/widgets/replacements/form_builder_dropdown.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart'
    hide FormBuilderDropdown;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:recase/recase.dart';

enum ThemeMode { auto, light, dark }

class DishfulDropdownField<T extends Enum> extends ConsumerWidget
    with DishfulFormField<T> {
  final String name;
  final T initialValue;
  final List<T> values;
  final String? labelText;
  final IconData icon;
  final List<String? Function(T?)>? additionalValidators;

  final Color? textColor;
  final Color? fillColor;
  final Color? iconColor;

  T getValue(FormBuilderState formBuilderState) =>
      getRawValue(formBuilderState) ?? initialValue;

  void clear(FormBuilderState formBuilderState) {
    setRawValue(formBuilderState, to: initialValue);
  }

  DishfulDropdownField({
    required this.name,
    required this.icon,
    required this.initialValue,
    required this.values,
    this.labelText,
    this.additionalValidators,
    this.textColor,
    this.fillColor,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  static DishfulDropdownField<ThemeMode> theme(BuildContext context) =>
      DishfulDropdownField(
        name: "theme",
        icon: Icons.palette,
        initialValue: ThemeMode.auto,
        values: ThemeMode.values,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderDropdown<T>(
      name: name,
      initialValue: initialValue,
      items: values
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value.name.titleCase),
              ))
          .toList(),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        ...additionalValidators ?? [],
      ]),
      dropdownColor: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.all(Radius.circular(4)),
      style: context.bodySmall!.copyWith(color: textColor),
      icon: Icon(Icons.expand_more, color: Palette.lightGrey).paddingOnly(
        right: 6,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: context.bodySmall!.copyWith(color: Palette.grey),
        fillColor: fillColor,
        prefixIcon: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
