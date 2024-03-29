import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthButton extends ConsumerWidget {
  final isLoadingProvider = StateProvider((_) => false);

  final String text;
  final Future<void> Function() onPressed;

  AuthButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              ref.set(isLoadingProvider, true);
              await onPressed();
              ref.set(isLoadingProvider, false);
            },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 26, horizontal: 22),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? Palette.lightGrey
              : Palette.secondary,
        ),
        textStyle: MaterialStateProperty.all(
          context.bodySmall!.copyWith(color: Palette.white),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLoading ? "Loading..." : text,
            style: context.bodySmall!.copyWith(color: Palette.white),
          ),
        ],
      ),
    );
  }
}
