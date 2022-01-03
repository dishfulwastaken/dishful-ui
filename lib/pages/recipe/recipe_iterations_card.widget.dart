import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:flutter/material.dart';

class RecipeIterationsCard extends StatelessWidget {
  final RecipeIteration _recipeIteration;

  RecipeIterationsCard(this._recipeIteration);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            _recipeIteration.id,
            textScaleFactor: 1.25,
          ),
          IconButton(
            onPressed: () async {
              await DbService.publicDb
                  .recipeIteration(_recipeIteration.parentId!)
                  .delete(_recipeIteration.id);
            },
            icon: Icon(Icons.delete),
          ),
          Text("# of Steps: ${_recipeIteration.steps.length}"),
          Text("# of Ingredients: ${_recipeIteration.ingredients.length}"),
        ],
      ),
    );
  }
}
