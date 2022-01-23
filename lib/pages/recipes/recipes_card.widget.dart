import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:flutter/material.dart';

class RecipesCard extends StatelessWidget {
  final RecipeMeta _recipe;

  RecipesCard(this._recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => RouteService.goToRecipe(context, _recipe.id),
        child: Column(
          children: [
            Text(
              _recipe.name,
              textScaleFactor: 1.25,
            ),
            IconButton(
              onPressed: () async {
                await DbService.publicDb.recipeMeta().delete(_recipe.id);
              },
              icon: Icon(Icons.delete),
            ),
            Text("ID: ${_recipe.id}"),
            Text("# Iterations: ${_recipe.iterationCount}"),
            Text("Description: ${_recipe.description}"),
          ],
        ),
      ),
    );
  }
}
