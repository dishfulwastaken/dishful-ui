import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension MyWidgetRef on WidgetRef {
  void set<T>(StateProvider<T> of, T to) {
    read(of.notifier).state = to;
  }
}

final isEditingProvider = StateProvider((ref) => false);

typedef DefaultChildBuilder = Widget Function();
typedef EditableChildBuilder = Widget Function(FocusNode);

abstract class EditableWidget<T> extends ConsumerWidget {
  abstract final DefaultChildBuilder defaultChildBuilder;
  abstract final EditableChildBuilder editableChildBuilder;
  abstract final T? editableChildController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMutating = ref.watch(isEditingProvider);
    final FocusNode focusNode = FocusNode();

    final onFocusChange = () {
      if (!focusNode.hasFocus) {
        ref.set(isEditingProvider, false);
      }
    };

    if (isMutating) {
      focusNode.requestFocus();
      focusNode.addListener(onFocusChange);
    }

    return isMutating
        ? editableChildBuilder(focusNode)
        : GestureDetector(
            child: defaultChildBuilder(),
            onLongPress: () => ref.set(isEditingProvider, true),
          );
  }
}

class EditableTextField extends EditableWidget<TextEditingController> {
  final controller = TextEditingController(text: "Recipes");

  @override
  DefaultChildBuilder get defaultChildBuilder => () => Text(controller.text);

  @override
  EditableChildBuilder get editableChildBuilder => (focusNode) => TextField(
        focusNode: focusNode,
        controller: controller,
      );

  @override
  TextEditingController get editableChildController => controller;
}
