import 'package:flutter/material.dart';

class _AsyncLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}

Widget asyncLoading() => _AsyncLoading();
