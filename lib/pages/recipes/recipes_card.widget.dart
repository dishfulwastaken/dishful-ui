import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dishful/common/data/maybe.dart';
import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/services/preferences.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/widgets/pictures/dishful_blur_hash_picture.widget.dart';
import 'package:dishful/common/widgets/pictures/dishful_picture.widget.dart';
import 'package:dishful/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:parallax_animation/parallax_animation.dart';

class RecipesCard extends StatelessWidget {
  final Recipe _recipe;

  RecipesCard(this._recipe);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RouteService.goRecipe(
        _recipe.id,
        recipe: _recipe,
        iterationId: PreferencesService.getLastOpenedIteration(
          recipeId: _recipe.id,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.width * 0.80,
            maxHeight: context.height * 0.5,
          ),
          child: ParallaxWidget(
            overflowWidthFactor: 1.2,
            background: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  child: DishfulBlurHashPicture(
                    blurHash: _recipe.pictures.maybeFirst?.blurHash,
                    width: _recipe.pictures.maybeFirst?.width,
                    height: _recipe.pictures.maybeFirst?.height,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Hero(
                    tag: "recipe-page-${_recipe.id}",
                    child: DishfulPicture(picture: _recipe.pictures.maybeFirst),
                  ),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 28,
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_recipe.name, style: context.titleMedium),
                      Container(height: 10),
                      Text(
                        "${_recipe.iterationCount} Iterations  |  ${_recipe.status.name.toTitleCase()}",
                        style:
                            context.bodyMedium!.copyWith(color: Palette.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
