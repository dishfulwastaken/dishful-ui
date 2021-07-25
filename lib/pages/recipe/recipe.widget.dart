import 'package:flutter/material.dart';

class Recipe extends StatelessWidget {
  final String id;

  Recipe(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Recipe $id!'),
      ),
    );
  }
}
