import 'package:dishful/common/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash/flash.dart';

final isEditingProvider = StateProvider((_) => false);

class EditableWidget extends ConsumerWidget {
  final Widget Function() defaultChildBuilder;
  final Widget Function(FocusNode) editableChildBuilder;
  final Future Function() onSave;
  final Future Function()? onEdit;

  EditableWidget({
    required this.defaultChildBuilder,
    required this.editableChildBuilder,
    required this.onSave,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider);
    final FocusNode focusNode = FocusNode();

    final onFocusChange = () async {
      if (!focusNode.hasFocus) {
        ref.set(isEditingProvider, false);
        try {
          await onSave();
          await context.showSuccessBar(content: Text("Successfully updated."));
        } on Exception {
          await context.showErrorBar(content: Text("Failed to save..."));
        }
      } else if (onEdit != null) {
        await onEdit!();
      }
    };

    if (isEditing) {
      focusNode.requestFocus();
      focusNode.addListener(onFocusChange);
    }

    return isEditing
        ? editableChildBuilder(focusNode)
        : GestureDetector(
            child: defaultChildBuilder(),
            onLongPress: () => ref.set(isEditingProvider, true),
          );
  }
}

class EditableTextField extends StatelessWidget {
  late final TextEditingController controller;
  final String? prefix;
  final TextStyle? style;
  final Future Function(String) onSave;

  EditableTextField({
    required this.onSave,
    this.prefix,
    this.style,
    String? initialValue,
    Key? key,
  }) : super(key: key) {
    controller = TextEditingController(text: initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return EditableWidget(
      defaultChildBuilder: () =>
          Text("$prefix ${controller.text}", style: style),
      editableChildBuilder: (focusNode) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(prefix ?? "", style: style),
          Container(width: 2),
          Flexible(
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              style: style,
              decoration: InputDecoration.collapsed(
                hintText: prefix,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
      onSave: () async => await onSave(controller.text),
    );
  }
}
