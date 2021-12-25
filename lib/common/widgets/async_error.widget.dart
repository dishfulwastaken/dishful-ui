import 'package:flutter/material.dart';

class _AsyncError extends StatelessWidget {
  final String error;
  final String stack;

  _AsyncError(this.error, this.stack);

  @override
  Widget build(BuildContext context) {
    return Text("Error: $error\nStack\n__________\n$stack");
  }
}

Widget asyncError(Object error, StackTrace? stack) =>
    _AsyncError(error.toString(), stack.toString());
