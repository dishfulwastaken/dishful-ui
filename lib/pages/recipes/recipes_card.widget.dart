import 'package:dishful/common/domain/recipe.dart';
import 'package:flutter/material.dart';

class RecipesCard extends StatelessWidget {
  final Recipe _recipe;

  RecipesCard(this._recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(_recipe.name),
          Text("Serves: ${_recipe.serves}"),
          Text(_recipe.description),
          Text(_recipe.status.toString()),
        ],
      ),
    );
  }
}
