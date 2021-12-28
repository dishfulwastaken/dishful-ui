import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:flutter/material.dart';

class RecipesCard extends StatelessWidget {
  final Recipe _recipe;

  RecipesCard(this._recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          RouteService.goToRecipe(context, _recipe.id);
        },
        child: Column(
          children: [
            Text(
              _recipe.name,
              textScaleFactor: 1.25,
            ),
            IconButton(
              onPressed: () async {
                await localDb.recipe.delete(_recipe.id);
              },
              icon: Icon(Icons.delete),
            ),
            Text("ID: ${_recipe.id}"),
            Text("Serves: ${_recipe.serves}"),
            Text("Spice Level: ${_recipe.spiceLevel}"),
          ],
        ),
      ),
    );
  }
}
