import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FadeScaleContainer extends ConsumerStatefulWidget {
  final Widget child;
  final StateProvider<bool> isVisibleProvider;

  const FadeScaleContainer({
    required this.child,
    required this.isVisibleProvider,
    Key? key,
  }) : super(key: key);

  @override
  _FadeScaleContainerState createState() => _FadeScaleContainerState();
}

class _FadeScaleContainerState extends ConsumerState<FadeScaleContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      value: ref.read(widget.isVisibleProvider) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(widget.isVisibleProvider);
    isVisible ? _controller.forward() : _controller.reverse();

    return FadeScaleTransition(
      animation: _controller,
      child: widget.child,
    );
  }
}
