import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Top level abstraction for all Dishful [FormBuilderField]s.
///
/// Removes the need for constants (the [name]s of fields) for each
/// field to safely access values. Any action that requires
/// the use of [name] should be done here.
abstract class DishfulFormField<T> {
  abstract final String name;

  void invalidate(FormBuilderState formBuilderState, String errorText) {
    formBuilderState.invalidateField(name: name, errorText: errorText);
  }

  bool matches(
    FormBuilderState formBuilderState, {
    required String otherName,
  }) =>
      getRawValue(formBuilderState) ==
      getRawValue(formBuilderState, withName: otherName);

  T getValue(FormBuilderState formBuilderState);
  void clear(FormBuilderState formBuilderState);

  @protected
  T? getRawValue(FormBuilderState formBuilderState, {String? withName}) =>
      formBuilderState.getRawValue(
        withName ?? name,
      );
  @protected
  void setRawValue(FormBuilderState formBuilderState, {required T to}) {
    formBuilderState.patchValue({name: to});
  }
}
