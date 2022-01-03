import 'package:dishful/common/data/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isMutatingProvider = StateProvider((ref) => false);

typedef MutableChildBuilder = Widget Function(FocusNode);

class MutableWidget extends ConsumerWidget {
  final Widget immutableChild;
  final MutableChildBuilder mutableChildBuilder;
  final FocusNode focusNode = FocusNode();

  MutableWidget({
    required this.immutableChild,
    required this.mutableChildBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMutating = ref.watch(isMutatingProvider);

    final onFocusChange = () {
      if (!focusNode.hasFocus) {
        // focusNode.removeListener(onFocusChange);
      }
    };

    if (isMutating) focusNode.addListener(onFocusChange);

    return isMutating
        ? mutableChildBuilder(focusNode)
        : GestureDetector(
            child: immutableChild,
            onLongPress: () => ref.set(isMutatingProvider, true),
          );
  }
}
