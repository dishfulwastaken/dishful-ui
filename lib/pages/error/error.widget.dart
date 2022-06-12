import 'package:dishful/common/widgets/dishful_error.widget.dart';
import 'package:dishful/common/widgets/dishful_scaffold.widget.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Exception error;

  const ErrorPage({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DishfulScaffold(
      title: "Oops...",
      body: (_) => DishfulError(
        error: error.toString(),
        stack: '',
      ),
    );
  }
}
