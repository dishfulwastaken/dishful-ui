import 'package:dishful/common/data/color.dart';
import 'package:dishful/common/data/providers.dart';
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
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 26, horizontal: 22),
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? Colors.black
              : HexColor.fromHex("#8fbfaf"),
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? TextStyle(fontFamily: "Montserrat", color: Colors.grey)
              : TextStyle(fontFamily: "Montserrat", color: Colors.white),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLoading ? "Loading..." : text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
